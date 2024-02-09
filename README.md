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
  
## STEP3. 구현 영상 
1. 
   
