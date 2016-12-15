# 오버워치(Overwatch) 캐릭터 한국버전 음성 정리

빈번히 업데이트 및 추가되는 캐릭터별 음성을 매번 다시 찾아볼 수 없어

OverTool에서 추출되는 hex 값 기준으로 꾸준히 정리하기로 함.

* **최종 추출 기준일**: 2016-12-15

## (테스트 위한) 음성 추출 방법

### .wem 파일 추출

[방법](https://owdev.wiki/User:Yukimono/Toolchain) 참고

```
# 윈도우즈
$ OverTool.exe -LkoKR C:\Games\Overwatch v D:\Documents\extracted
```

### .wem => .ogg 변환

[이 문서](http://forum.xentax.com/viewtopic.php?p=66311#p66311)의 **Guide: Converting .wem to .ogg** 참고

### .ogg => .wav/.m4a 변환

ffmpeg 활용:

```
$ ffmpeg -i xxxxx.ogg -ar 44.1k xxxxx.wav

$ ffmpeg -i xxxxx.wav -b:a 192k xxxxx.m4a
```

## 테스트 방법

### 1. 'sounds' 폴더 안에 추출 캐릭터 음성들을 복사

sounds 폴더 안에는 캐릭터별로 (OverTool에서 추출해준대로) 캐릭터명 폴더로 분류하여 넣도록 함.

(단, '솔저: 76'의 경우 중간의 특수문자로 인해 '솔저76'으로 대체)

### 2. 아직 채워지지 않은 음성 확인

`2_fill_txt.rb` 스크립트 실행하여 음성 확인 및 .sqlite 파일에 해당 값 채워넣음

```
$ ./2_fill_txt.rb 솔저76
```

### 3. 새로운 음성파일 추가 되었을 시

파일 복사 후 `2_add_voices.rb` 스크립트 실행한 뒤 다시 2번 실행

### 4. 최종 결과물 생성

.sqlite 파일을 수정한 경우, `3_sqlite_to_csv.rb` 스크립트를 실행하여 최종 .csv 파일 생성.

반대로, .csv 파일을 수정한 경우, `3_csv_to_sqlite.rb` 스크립트를 실행하여 최종 .sqlite 파일 생성.

### 5. 기타

`4_gen_list.rb` 스크립트를 실행하여 음원을 재생해볼 수 있는 HTML 파일 생성.

`5_rename_files.rb` 스크립트를 실행하여 hex로 되어 있는 파일들을 [영웅]\_[대사]\_[hex].m4a로 복사.

## 도움 요망

- [ ] 캐릭터 대사 철자, 부호 교정
- [ ] 누락 외국어 추가 (아랍어, 프랑스어, 영어, 중국어, 러시아어, ...)
- [ ] 효과음 음성 구분 (신음, 한숨, ...)

