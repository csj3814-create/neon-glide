# NEON GLIDE 런칭 문구

핵심 훅은 하나로 고정한다: **"오늘은 전 세계가 같은 코스를 난다."**
Wordle이 통한 이유와 같다 — 매일 리셋되고, 모두가 동일한 조건이고, 점수를 비교할 이유가 생긴다.
게임 자체의 참신함보다 이 구조를 앞세운다.

링크: https://neon.habitschool.kr/ · https://sukjae.itch.io/neon-glide

---

## 1. Hacker News — Show HN

기술 각도로 간다. HN은 게임 자체보다 "단일 78KB 파일"에 반응한다.
평일 미국 동부 기준 오전 8~10시 제출. 제목은 80자 제한.

**제목**
```
Show HN: A daily one-button game in a single 89KB HTML file
```

**본문**
```
Every player in the world flies the identical course each day. The course is
generated from a seeded PRNG keyed to the UTC date, so there's no level data to
ship and no server to ask — the client derives the same world everyone else got.
The leaderboard resets at 00:00 UTC.

The whole game is one HTML file: no build step, no framework, no external
assets. Music is synthesized with WebAudio, graphics are canvas primitives.
89KB, and it runs offline after first load.

Two things I got wrong and had to fix:

- canvas shadowBlur is rasterized on the CPU every frame. Three full-height
  glowing pillars took 2.06ms/frame. Replacing the glow with three layered
  translucent fills got it to 0.34ms — 6x, same look.
- The game originally scaled to the viewport, which quietly made phones harder
  than desktops: a smaller screen meant less reaction distance. Now everything
  renders to a fixed 1280x720 virtual field that's contain-fit scaled, so the
  difficulty is identical everywhere.

Leaderboard writes go through Firebase anonymous auth — no login prompt, but
each device gets an identity, so scores can only be improved by their owner
instead of POSTed by anyone with curl (which is how it worked at first).

https://neon.habitschool.kr/
```

---

## 2. r/WebGames

플레이어 각도. 자기홍보 허용되지만 규칙 확인 필수.

**제목**
```
[HTML5] NEON GLIDE — everyone in the world flies the same course each day, leaderboard wipes at midnight UTC
```

**본문**
```
One button: hold to rise, let go to drop. A brakes, D boosts, and you've got a
limited energy bar for both — knowing when to slow down matters more than
reflexes once the gates start moving.

The hook is that the course is seeded from today's date, so the run you're
looking at is the exact run everyone else is looking at. Beat someone's score
and you know you beat them on identical ground. Resets 00:00 UTC.

No install, no signup, no ads. Works on phones (hold it in portrait, it rotates
itself). Nine languages. Free.

https://neon.habitschool.kr/

Collect 10 stars and you hit MAX — at x10 multiplier you stop dying instantly
and start trading stars for survival, which is where the runs get interesting.
```

---

## 3. r/playmygame

피드백 요청 형식이 규칙이다. 질문으로 끝낸다.

**제목**
```
[HTML5] NEON GLIDE — a daily-seeded one-button flyer. Looking for feedback on the difficulty curve.
```

**본문**
```
Play in browser, nothing to install: https://neon.habitschool.kr/

Everyone gets the same course each day (seeded off the UTC date), so the global
leaderboard is a fair comparison. It resets at midnight UTC.

What I'd like feedback on: the difficulty ramp. Gates start moving at 4, lasers
show up at 9, and pulsing gaps at 7. Playtesters split hard — some stall out
around gate 5, others get to 15 on their second run. I can't tell if that's a
tuning problem or just the spread you'd expect.

Also curious whether the brake (A) reads as useful. It's the mechanic people
seem to discover last, and it's the one that makes the late gates survivable.
```

---

## 4. X / 트위터

동영상이 전부다. `promo\trailer-20s.mp4` 첨부 (X는 WebM을 받지 않으므로 반드시 MP4).

**본문**
```
Everyone on Earth flies the same course today.

Tomorrow, a different one.

NEON GLIDE — one button, daily seeded, global leaderboard that wipes at
midnight UTC. No install, no signup. It's one 89KB HTML file.

https://neon.habitschool.kr/
```

---

## 5. itch.io 데블로그

이미 팔로워가 있고 itch.io 피드에 노출된다. 업데이트 알림 목적.

**제목**
```
Now installable, twice as smooth, and the leaderboard is finally tamper-proof
```

**본문**
```
A big pass over everything that was holding the game back.

**Plays the same on every device.** The game used to scale to your viewport,
which quietly punished phone players — a smaller screen meant less room to
react. Everything now renders to a fixed virtual field, so the course is
identical whether you're on a monitor or a phone. Portrait phones rotate
themselves; there's a fullscreen button for the rest.

**Install it.** Add it to your home screen and it runs offline, fullscreen, no
browser chrome.

**Much smoother.** Cut the per-frame work down hard — the glowing gates were
costing 6x more than they needed to, and the starfield, grid and speed lines
now draw in single batched passes.

**MAX POWER is a shield now.** At x10, hitting a wall costs you 10 stars
instead of the run. Lasers cost 5. You get a moment of invulnerability and keep
flying.

**The leaderboard can't be forged.** Scores used to be a plain public write —
anyone could have posted anything. Every device now silently gets its own
identity, and a score can only be improved by the person who set it. You won't
notice anything: still no login, still no signup.

Touch controls got a proper layout too — right half to rise, left half split
into boost and brake.
```

---

## 6. 국내 커뮤니티

한국어판이 있으니 국내가 초기 리더보드 채우기엔 가장 빠르다.
**클리앙 '모두의공원'**, **루리웹 '인디게임 게시판'**이 자작 게임에 관대하다.
DCinside·에펨코리아는 링크 홍보에 적대적이니 피한다.

**제목**
```
매일 전 세계가 같은 코스를 나는 웹게임 만들었습니다
```

**본문**
```
버튼 하나로 하는 게임입니다. 누르면 오르고 떼면 떨어집니다.

특이한 점은 코스가 매일 날짜로 생성돼서, 오늘 여러분이 보는 코스가 전 세계
모든 사람이 보는 그 코스라는 겁니다. 순위표도 매일 0시(UTC)에 초기화됩니다.
누굴 이겼으면 정확히 같은 조건에서 이긴 게 맞습니다.

설치도 가입도 없고 광고도 없습니다. 폰에서도 됩니다(세로로 들면 알아서
돌아갑니다). 한국어 지원합니다.

https://neon.habitschool.kr/

A는 감속, D는 가속이고 에너지가 제한돼 있습니다. 반사신경보다 언제 속도를
줄일지가 중요해지는 순간이 옵니다. 별 10개 모아서 MAX 되면 벽에 부딪혀도
별을 깎고 살아남습니다.
```

---

## 진행 상황 (2026-07-22 기준)

- ✅ **itch.io 데블로그** — 게시 완료
- ✅ **X** — 게시 완료
- ✅ **루리웹 게임개발 게시판** — 게시 완료 (클리앙은 계정 이용권한 부족으로 불가)
- ✅ **r/WebGames** — 게시 완료, automod 통과
- ⬜ **r/playmygame** — 다음 차례
- ⬜ **Show HN** — 리더보드에 사람이 어느 정도 찬 뒤. 빈 순위표를 보여주면 손해다.

이미 올린 글들의 링크는 구 주소(`csj3814-create.github.io/neon-glide/`)지만 301 리다이렉트로
살아 있다. 앞으로 올리는 글에만 짧은 주소를 쓴다.

**계정 나이 문제.** Reddit은 새 계정의 링크 게시물을 자동으로 지운다. 각 서브레딧
규칙(사이드바)을 먼저 읽고, 며칠 댓글 활동으로 카르마를 쌓은 뒤 올린다.
하루에 여러 서브레딧에 같은 글을 도배하면 스팸으로 계정이 정지된다.
**서브레딧 하나당 하루 한 개, 최소 하루 간격.**

**답글이 본편이다.** 올린 뒤 몇 시간 동안 댓글에 답하는 게 노출을 좌우한다.
특히 HN과 r/playmygame은 작성자가 응답하지 않으면 그대로 가라앉는다.
