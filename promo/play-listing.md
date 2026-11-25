# Play 스토어 등록정보 — NEON GLIDE

하루 3런 구조(2026-11-25)에 맞춰 다시 쓴 초안. 예전 문구는 단일 코스 시절 것이라
"오늘의 코스 하나"를 전제로 하고 있어 그대로 쓸 수 없다.

패키지: `io.github.csj3814_create.neonglide`
업로드할 번들: `android/twa/app/build/outputs/bundle/release/neon-glide-v2-signed.aab`
(versionCode 2 / versionName 1.0.1)

---

## 앱 이름 (30자 이내)

```
NEON GLIDE
```

## 간단한 설명 (80자 이내)

한국어 — 37자

```
하루 세 코스, 전 세계가 같은 코스. 한 손가락으로 겨루는 네온 글라이더.
```

English — 76 characters

```
Three daily courses, the same for everyone. One-button neon glider racing.
```

---

## 자세한 설명 (4,000자 이내)

### 한국어

```
한 손가락으로 조종하는 네온 글라이더.
누르면 올라가고, 떼면 내려갑니다. 조작은 그게 전부입니다.

■ 전 세계가 매일 똑같은 세 코스를 달립니다
날짜로 생성되는 코스라 서울에서도 상파울루에서도 오늘의 게이트 배치는 완전히
같습니다. 운이 아니라 실력만 비교됩니다.

■ 하루에 세 번의 완주
RUN 1 워밍업 — 게이트 26개. 넓은 통로에서 라인을 익힙니다.
RUN 2 본편 — 게이트 50개. 움직이는 벽, 갈라진 통로, 레이저.
RUN 3 클라이맥스 — 게이트 40개. 가장 빠르고 가장 좁습니다.
하나를 완주해야 다음이 열리고, 셋을 모두 끝내면 어느 코스든 무제한으로 다시
달려 기록을 올릴 수 있습니다. 오늘의 점수는 세 코스 최고점의 합입니다.

■ 안전 운전으로는 못 이깁니다
그냥 지나가는 건 거의 점수가 되지 않습니다. 통로 가장자리를 스치고(CLOSE),
레이저를 뚫고(THREAD), 부스트로 통과할 때 ★ 체인이 쌓이고 배율이 ×10까지
올라갑니다. 밋밋하게 지나가면 체인이 깎입니다.

■ 글로벌 Top 10
같은 코스를 달린 전 세계 기록과 바로 비교됩니다. 1위의 주행 궤적이 고스트로
함께 달리고, 내 최고 기록도 나란히 재생됩니다.

■ 메달과 연속 완주
세 코스를 모두 끝낸 날에만 그날의 메달이 찍힙니다. 최근 14일 달력에서 동·은·
금·플래티넘을 한눈에 보고, 연속 완주 기록을 이어가세요.

■ 오프라인에서도
설치하면 인터넷 없이도 그날 받아둔 코스를 달릴 수 있습니다. 광고 없음,
인앱 결제 없음, 계정 가입 없음.

한 판은 1분 남짓. 하루치는 3분 남짓. 그런데 ×10 체인으로 완주하는 날은
좀처럼 오지 않습니다.
```

### English

```
A one-button neon glider.
Hold to rise, release to dive. That is the whole control scheme.

■ The whole world runs the same three courses every day
Courses are generated from the date, so today's gate layout is identical in
Seoul and in Sao Paulo. Nothing is left to luck — only to how you fly.

■ Three finishes a day
RUN 1 Warm-up — 26 gates. Wide lanes to find your line.
RUN 2 Main — 50 gates. Moving walls, split lanes, lasers.
RUN 3 Climax — 40 gates. The fastest and the tightest.
Clear one to unlock the next. Clear all three and you can replay any of them
as often as you like to improve. Your daily score is the sum of your best on
each course.

■ Playing it safe will not win
Simply passing a gate is worth almost nothing. Shave the edge of a lane
(CLOSE), thread a laser (THREAD) or pass under boost, and your star chain
builds the multiplier up to x10. A lazy pass chips it back down.

■ Global Top 10
Your score lands straight against everyone who ran the same course. The
leader's line runs beside you as a ghost, and so does your own best.

■ Medals and clear streaks
A day earns its medal only when all three courses are finished. Track bronze,
silver, gold and platinum across the last 14 days and keep the streak alive.

■ Works offline
Once installed, the day's courses run without a connection. No ads, no in-app
purchases, no account.

One run takes about a minute. A full day takes about three. Finishing all
three on a x10 chain takes rather longer than that.
```

---

## 스크린샷

`dist/play-assets-new/` (gitignore 대상이므로 저장소에는 없음)

| 파일 | 크기 | 내용 |
|---|---|---|
| `run-select.jpg` | 800×450 | 런 선택 화면 — RUN 1·2 금메달, RUN 3 대기, 오늘 합계 |
| `run1.png` | 1280×720 | RUN 1 주행 — 넓은 통로, CLOSE+BOOST, ×7 |
| `run2.png` | 1280×720 | RUN 2 주행 — 갈라진 통로와 레이저, ×10 |
| `run3.png` | 1280×720 | RUN 3 주행 — 좁은 통로, 레이저, ×10 MAX 트레일 |

게임 화면 3장은 캔버스에서 직접 1280×720으로 내보낸 것이라 브라우저 크롬이나
커서가 없다. 런 선택 화면은 DOM 오버레이라 캔버스 내보내기가 안 돼 창 캡처를
썼고 그래서 800×450이다 — Play 최소 요건(한 변 320px 이상, 16:9)은 충족하지만
나머지 셋보다 덜 선명하다. 더 크게 필요하면 큰 화면에서 다시 찍으면 된다.

그대로 쓸 수 있는 기존 에셋:
- 아이콘 512×512 — `dist/play-assets/1-app-icon-512x512.png`
- 기능 그래픽 1024×500 — `feature-graphic.png`

## 등록정보에서 바뀌어야 할 것

- 예전 설명의 "오늘의 코스" 단수 표현 → 세 코스 구조로
- 예전 스크린샷은 단일 60게이트 코스 시절이라 HUD가 `n / 60`으로 찍혀 있다
- 데이터 보안 양식: 수집 항목은 리더보드에 올리는 **표시 이름뿐**이다(선택 입력,
  계정 없이 익명 인증). 위치·연락처·기기 ID 수집 없음, 광고 없음.
