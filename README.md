# 자유 Project : 업무 자동화를 위해 Terraform 으로 3-Tier와 Prometheus, Grafana 자동 구축
![image](https://github.com/RoDawn/ncpproject/assets/143478463/2c8d8a17-dc90-4829-ba1b-82b0ba240a2d)
- **기간 :** 2024.01.18 ~ 2024.01.21
- **팀 프로젝트** (3명)
- **나는? :** 'Terraform 을 이용해 NCP 3-Tier 코드 제작', 'PPT 공동 제작 참여', '프로젝트 발표' 
- **주제 선정 이유 :** 평소 Concole 을 이용해 클라우드 인프라를 구축했습니다. ACG Rule부터 Subnet까지 많은 옵션을 수동으로 설정했습니다. 그러다 보니 반복 작업임에도 시간 단축이 되지 못 하며, Port를 잘못 설정하는 등의 실수가 빈번했습니다. 그래서 IaC를 이용해 자동화를 할 수 있다면 실수, 작업 시간을 단축 할 수 있을 것이란 생각으로 선정하게 되었습니다. 

## STEP1. 아키텍쳐
![image](https://github.com/RoDawn/ncpproject/assets/143478463/23668ff5-c9c7-43a4-9d66-6c412ac5351f)
- **Point1 :** 별도의 관리 서버를 Public에 두고, 3-Tier는 모두 Privat으로 구축, 유저는 ALB를 통해 접근
- **Point2 :** Terraform 으로 3-Tier, Load Balanacer 까지 구축
- **Point3 :** Grafana 와 Prometheus 까지 구축

## STEP2. 사용 기술
- AWS & NCP : VPC, ACG, Subnet, EC2 & VM, Load Balancer
- OS : CentOS
- NginX, Apache Tomcat
- MySQL
  
## STEP3. 구현 사진
1. NCP Terraform Apply
![image](https://github.com/RoDawn/ncpproject/assets/143478463/694d1830-a783-4f7e-994d-0bba181ed660)

2. AWS Terraform Apply
![image](https://github.com/RoDawn/ncpproject/assets/143478463/f538c62b-e090-40e5-935b-0557793cd0c4)

## STEP4. 결과
- 3-Tier 까지 구축한다고 했을 때, Concole은 13분 -> Terraform 6분, 작업 시간 2배 단축
- Prometheus, Grafana 설치 스크립트도 포함 시켜서 Node 역할로 프로비저닝
   
## STEP5. NEXT Action
- NLB & Auto-Scaling 도 Terraform으로 코드 작성하기

## STEP6. 느낀점
- Concole로 작업했을 때 ACG Rule 등 Network 쪽에서 많은 실수가 발생했었습니다. Terraform 으로 작업하면 실수가 거의 0%에 가까워졌기에 작업의 효율성이 증가해서 좋았습니다.
- 동일한 3-Tier를 3개 구축한다고 했을 때, 일일이 손으로 다 설정해줘야 하는 불편함이 있었습니다. IaC 덕분에 동일한 작업 경우 시간을 엄청 단축할 수 있었습니다.
- 클라우드만 공부하다가 Code 계열의 작업을 해서 적응하는데 시간이 오래 걸렸습니다. 욕심 같아선 Terraform code 한 줄을 전부 해석 할 수 있으면 좋겠지만 당장은 과하다고 생각했습니다. 우선은 공식 문서 등에 나와있는 코드를 활용하며 하나의 코드 묶음이 어떤 역할을 하는지, 만약 CIDR 등을 바꾸고 싶다면 어떤 것을 바꿔야 하는지? 위주로 활용해가고자 합니다.
