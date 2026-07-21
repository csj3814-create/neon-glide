# 트레일러용 영상 생성 프롬프트

게임의 실제 요소만 묘사한다 — 흰 화살촉 기체, MAX 상태의 무지개 꼬리,
시안/마젠타 게이트 기둥, 보라색 원근 격자, 별 입자. 실물과 다른 걸 넣으면
플레이어가 기대한 게임과 다른 걸 받게 되므로 화려함보다 정확도를 우선한다.

**이 영상은 게임플레이 화면이 아니다.** 분위기 컷으로만 쓰고, 실제 플레이 영상
(`dist\gameplay-landscape.webm`)과 붙여서 트레일러를 만든다. 단독으로 올리면
게임플레이를 사칭하는 것이 된다.

권장 설정: 16:9 · 1080p · 8초

---

## 1. 메인 컷 — 게이트 통과

```
A sleek white arrowhead craft streaks left to right through an endless dark violet
corridor, trailing a long ribbon of rainbow light behind it. It threads a narrow gap
between two towering vertical neon pillars, one cyan and one magenta, which bloom and
flare as it passes. Tiny star specks drift by; a faint purple perspective grid stretches
across the floor below. The camera tracks alongside at high speed with light streaks and
subtle motion blur. Retro synthwave arcade aesthetic, deep black background, saturated
neon glow, clean flat vector shapes. No text, no logos, no people.
```

## 2. 오프닝 컷 — 정적에서 출발

```
A single white arrowhead craft hangs motionless in a vast dark violet void, a faint cyan
glow pulsing around it. Star specks drift slowly. Then it snaps forward and accelerates
away from camera, a rainbow trail unfurling behind it as speed lines streak past. A purple
perspective grid rushes in from below. Retro synthwave arcade aesthetic, deep black
background, saturated neon, clean flat vector shapes. No text, no logos, no people.
```

## 3. 클로징 컷 — 속도의 끝

```
Camera locked behind a white arrowhead craft flying away down an infinite neon corridor.
Cyan and magenta pillars rush past on both sides in rhythmic pulses, each flaring as it
passes. A rainbow trail streams back toward camera. Speed lines multiply until the frame
is streaks of light, then the craft shrinks to a bright point in the darkness. Retro
synthwave arcade aesthetic, deep black background, saturated neon. No text, no logos,
no people.
```

---

## 사용 가능한 곳

Higgsfield 무료 플랜은 크레딧 10으로, 가장 싼 영상(Seedance 2.0 Mini, 720p 8초)이
20 크레딧이라 생성 불가. 유료 전환 없이 쓰려면 다른 서비스의 무료 한도를 쓰거나,
실제 플레이 영상만으로 트레일러를 구성한다.

이미 확보된 소재:
- `dist\gameplay-landscape.webm` — 실제 플레이 (가로)
- `dist\gameplay-portrait.webm` — 실제 플레이 (세로, 릴스/쇼츠용)
- `og-card.png` — 1200x630 소셜 카드
- `promo\screenshot-max-gate49.png` — MAX 상태 원본 스크린샷
