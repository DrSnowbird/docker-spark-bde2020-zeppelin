---
- name: deploy pyspark script
  hosts: myCluster
  remote_user: datascience
  
  vars:
    source_path: /repo/src/python/
    dest_path: /python/
    job_script: Test.Ansible.py
    executors: 10
    pipe_task: job_pipeline
    
  tasks:
    - name: "transfer python scripts: {{job_script}}"
      copy: src={{source_path}}/{{job_script}} dest={{dest_path}}/{{job_script}}
      
    - name: "transfer runner"
      copy: src={{source_path}}/runner.sh dest+{{dest_path}}/runner.sh mode=ug+rx
      
    - name: "spark_submit: ./runner.sh {{job_script} QUEUE EXECUTORS PIPELINE_TASK"
      shell: "{{dest_path}}/runner.sh {{job_script}} datascience {{executors}} {{pipe_task}}"
      args:
        chdir: "{{dest_path}}"
        executable: /bin/bash
        
    - name: "Wait for log: {{job_script}}.datascience.log"
      wait_for: path={{dest_path}}/{{job_script}}.datascience.log timeout=15
      

    
