---
layout: post
title: 깃허브 블로그 만드는 방법  
category: github 
tags: [github, jekyll]
no-post-nav: true
---

1. git 설치 
https://gitforwindows.org/

2. ruby 설치 (jekyll 설치 하려면 필요)
https://rubyinstaller.org/downloads/

3. jekyll 설치 
`gem install jekyll`

4. github페이지에서 새로운 repository 생성, 이름은 반드시 아래의 형식을 따라야 함 
`[깃허브유저명].github.io  예. 2econsulting.github.io`

5. 로컬 컴퓨터 특정 폴더(C:\Users\jacob\Documents\GitHub\2econsulting\2econsulting.github.io)에 clone 하기 
```
cd C:\Users\jacob\Documents\GitHub\2econsulting
git clone https://github.com/2econsulting/2econsulting.github.io.git
```

6. jekyll themes 중에서 하나 선택 후 테마파일(zip) 해당 폴더에 다운로드
http://jekyllthemes.org/

7. 다운로드 파일 압축 풀고 commit & push하면 깃허브 블러그 생성 완료
```
git status
git add .
git commit -m "post upload"
git push origin master 
```

8. 기타, 블로그에 댓글 기능 추가
http://recoveryman.tistory.com/391?category=635733
