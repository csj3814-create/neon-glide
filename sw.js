// NEON GLIDE service worker — 오프라인 플레이 + 빠른 재실행
// 게임 본문(HTML)은 네트워크 우선이라 배포한 변경이 다음 실행에 바로 보이고,
// 아이콘·매니페스트 같은 정적 셸은 캐시 우선이라 재실행이 즉시 뜬다.
// 네트워크가 없으면 둘 다 캐시로 떨어져 오프라인 플레이는 그대로 유지된다.
const CACHE = 'neon-glide-v6';
const SHELL = ['./', './index.html', './manifest.webmanifest', './icon-192.png', './icon-512.png', './icon-maskable-512.png'];

self.addEventListener('install', e => {
  e.waitUntil(caches.open(CACHE).then(c => c.addAll(SHELL)).then(() => self.skipWaiting()));
});

self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys()
      .then(keys => Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k))))
      .then(() => self.clients.claim())
  );
});

function cacheIfOk(req, res) {
  if (res && res.status === 200 && res.type === 'basic') {
    const copy = res.clone();
    caches.open(CACHE).then(c => c.put(req, copy));
  }
  return res;
}

self.addEventListener('fetch', e => {
  const req = e.request;
  if (req.method !== 'GET') return;
  const url = new URL(req.url);

  // 리더보드(Firebase)와 외부 SDK는 항상 네트워크 우선 — 캐시하면 순위가 굳어버린다
  if (url.origin !== self.location.origin) return;

  // 게임 본문: network-first.
  // 캐시 우선으로 주면 기존 플레이어가 업데이트 다음 실행까지 옛 빌드를 보게 된다.
  if (req.mode === 'navigate') {
    e.respondWith(
      fetch(req)
        .then(res => cacheIfOk(req, res))
        .catch(() => caches.match(req).then(cached => cached || caches.match('./index.html')))
    );
    return;
  }

  // 정적 셸: stale-while-revalidate
  e.respondWith(
    caches.match(req).then(cached => {
      const net = fetch(req).then(res => cacheIfOk(req, res)).catch(() => cached);
      return cached || net;
    })
  );
});
