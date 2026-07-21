// NEON GLIDE service worker — 오프라인 플레이 + 빠른 재실행
// 게임 셸은 캐시에서 즉시 띄우고, 백그라운드로 최신본을 받아 다음 실행에 반영한다.
const CACHE = 'neon-glide-v1';
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

self.addEventListener('fetch', e => {
  const req = e.request;
  if (req.method !== 'GET') return;
  const url = new URL(req.url);

  // 리더보드(Firebase)와 외부 SDK는 항상 네트워크 우선 — 캐시하면 순위가 굳어버린다
  if (url.origin !== self.location.origin) return;

  // 게임 셸: stale-while-revalidate
  e.respondWith(
    caches.match(req).then(cached => {
      const net = fetch(req).then(res => {
        if (res && res.status === 200) {
          const copy = res.clone();
          caches.open(CACHE).then(c => c.put(req, copy));
        }
        return res;
      }).catch(() => cached);
      return cached || net;
    })
  );
});
