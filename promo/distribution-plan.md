# NEON GLIDE 배급 계획 (트래픽 뚫기)

7일 실측: 홍보 직후 하루 4~5명 → 이후 0~2명. 유기적 트래픽 사실상 0.
글(카피)은 이미 충분히 뿌렸고 계정 신뢰도 벽에 막혔다. 남은 진짜 레버는
**계정 나이와 무관하게 자체 확산되는 포맷 = 짧은 세로 영상**, 그리고
**한 방 런치 채널 = Product Hunt**.

---

## 1순위: 숏폼 세로 영상 (TikTok / YT Shorts / Reels / 인스타)

캐주얼 웹게임이 2026년에 실제로 터지는 곳. 새 계정도 조회수가 터지면 확산된다.
`promo/vclip.html` 로 1080×1920 클립을 뽑는다 (게임 화면 중앙 + 상단 훅 + 하단 주소).

**만드는 법**
1. `http://localhost:8080/promo/vclip.html` 열기 (정적 서버 필요)
2. 재생 → 좋은 구간에서 멈춤 (×10 무지개 꼬리 구간 추천, 원본 100~140초대)
3. 상단 훅 문구 바꿔가며 3~5개 뽑기 → 다운로드 폴더에 MP4 저장

**클립마다 다른 훅으로 A/B (첫 1초가 전부)**
- "Everyone flies the SAME course today"
- "The whole world got this exact run today"
- "One button. One daily course. Global leaderboard."
- "매일 전 세계가 똑같은 코스를 난다" (국내용)
- "이 코스, 오늘 전 세계가 똑같이 받았다"

**포스팅 원칙**
- 하루 1~2개, 매일. 숏폼은 양이 곧 복권 장수다.
- 캡션 짧게 + 주소 + 해시태그: `#browsergame #html5game #onebutton #dailychallenge #indiegame #웹게임 #무료게임`
- 첫 댓글에 주소 한 번 더 (플랫폼이 설명란 링크를 죽이는 경우 대비).
- 반응 좋은 훅/구간을 다음 클립에 몰아준다.

**주의**: AI 생성 영상 아님(실제 플레이 캡처)이라 "게임과 다르다" 역풍 없음.

---

## 2순위: Product Hunt 런치 (한 방, 계정 벽 없음)

PH는 카르마 벽이 없고, "매일 시드 코스 + 글로벌 리더보드"라는 영리한 메커닉이
PH 취향에 맞는다. 화~목 태평양시간 00:01 런치가 노출에 유리.

**Name**: NEON GLIDE
**Tagline (60자)**: The whole world flies the same one-button course every day
**Topics**: Games, Web App, Fun
**Links**: https://neon.habitschool.kr/

**Description**:
```
NEON GLIDE is a one-button glider you play in the browser — no install, no
sign-up, no ads. Hold to rise, let go to drop.

The twist: today's course is generated from today's date, so the run you're
looking at is the exact run everyone else in the world is looking at. Beat
someone on the leaderboard and you beat them on identical ground. At midnight
UTC it resets and a brand-new course appears.

Under the hood it's a single 89KB HTML file — no framework, no build step, no
assets. The course is a seeded PRNG keyed to the UTC date, so there's no level
data to ship and no server to ask; every client derives the same world. Music
is synthesized with WebAudio, everything renders to a fixed virtual resolution
so a phone plays the exact same difficulty as a desktop.

Free, in nine languages, installable as a PWA. Come set today's high score.
```

**First comment (maker)**:
```
Maker here. I wanted the "everyone competes on the same board" feeling of Wordle
but for an action game, so the whole world flies one shared daily course.

Two things I nerded out on: the course is a date-seeded PRNG (no level data, no
server — the client just derives today's world), and the whole thing is one 89KB
HTML file that runs offline. Happy to answer anything about how it's built.

What's your score on today's course?
```

---

## 3순위: 아직 안 뚫은, 규칙에 맞는 커뮤니티

- **r/proceduralgeneration** — "날짜 시드 PRNG로 전 세계 동일 코스"는 여기 기술 취향에 정확히 맞는다. 게임 홍보가 아니라 기법 공유 각도로.
- **아카라이브 / DCinside 인디게임 갤러리** — 카르마 벽 없음, 국내 유입. 반응은 복불복.
- **오늘의유머·뽐뿌 유머게시판** — "매일 코스" 훅으로 가볍게.
- 루리웹은 1개월 재게시 제한, 클리앙은 계정 권한 부족(그대로).

---

## 안 하는 것 / 막힌 것
- r/playmygame: AI 개발 + Flappy 클론 조항 → 안 함.
- Hacker News: 신규 계정 Show HN 제한 → 카르마 쌓은 뒤.
- CrazyGames: 품질 2회 반려 → 접음.

## 냉정한 기대치
숏폼은 대부분 안 터지고 가끔 하나 터지는 게임이다. Product Hunt는 하루짜리
스파이크. 둘 다 "될 때까지 양으로" 미는 채널이고, 한 클립/한 런치로 판단 금물.
이게 통하면 GD·Play의 광고 수익이 비로소 볼륨을 받는다.
