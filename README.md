Name:BadAssWall_v0.1
Unstable
Sysadmin: voucolocar@umemail.aqui
Homolação: Debian Jessie. 

Note_0x01:
A Ideia desse firewall é criar um firewall dinamico devido a gama de configurações que podem ser feitas direto pelo arquivo principal (packetkiller.sh), a partir desse script vai ter uma sessão de logs com verbose alta, para debbug/troubleshooting, a ideia é gerar arquivos .conf para as tables filter, nat e mangle, onde cada arquivo vai configurar as respectivas chains.

Preste atenção no script principal pois faz alterações diretas no kernel, é de suma importancia que você esteja usando um sistema homologado por mim, para evitar crash no sistema/serviço de firewall. 

O firewall tenta adotar melhores práticas de mitigação de DDoS, com base em pesquisas feitas por mim à artigos relacionados. 

Projeto:
função Clean: Tem como ideia limpar o firewall, utilizada na inicialização do script.
função callfilter: Executa os scripts da table filter
função callnat: Executa os scripts da table nat
função callmangle: Executa os scripts da table mangle

função kernel4win: Executa as configurações do Kernel, recomendo a leitura do script antes da implementação, já que esse firewall é generico, pode ser que dê algum problema especifico no ambiente qual você utiliza.
Informações téncnicas:


log/powerup.log -> Vai gerar os logs cada vez que o script iniciar. 

