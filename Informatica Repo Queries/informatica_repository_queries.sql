/*
List of Users and groups having privileges’ on Folders
*/

SELECT opb_subject.subj_name                                           folder_name,
       opb_user_group.name                                             user_name,
       Decode (opb_object_access.user_type, 1, 'USER', 2, 'GROUP')     TYPE,
       CASE
         WHEN ( ( opb_object_access.permissions - ( opb_object_access.user_id + 1 ) ) IN ( 8,16 ) )   THEN 'READ'
         WHEN ( ( opb_object_access.permissions - ( opb_object_access.user_id + 1 ) ) IN ( 10,20 ) )  THEN 'READ & EXECUTE'
         WHEN ( ( opb_object_access.permissions - ( opb_object_access.user_id + 1 ) ) IN ( 12,24 ) )  THEN 'READ & WRITE'
         WHEN ( ( opb_object_access.permissions - ( opb_object_access.user_id + 1 ) ) IN ( 14,28 ) )  THEN 'READ, WRITE & EXECUTE'
         ELSE 'NO PERMISSIONS' END                                      permissions
         
FROM   opb_object_access opb_object_access,
       opb_subject opb_subject,
       opb_user_group opb_user_group
       
WHERE  opb_object_access.object_type = 29
       AND opb_object_access.object_id = opb_subject.subj_id
       AND opb_object_access.user_id = opb_user_group.id
       AND opb_object_access.user_type = opb_user_group.TYPE
       AND opb_user_group.NAME not in ('Admin','READ_ONLY','Administrator','Administrators')
       
ORDER  BY 1,2,3;


/*

Generate List of Workflows, Session and Mapping names list for given folder in Informatica

*/
SELECT   REP_WORKFLOWS.WORKFLOW_NAME,
         REP_TASK_INST.INSTANCE_NAME SESSION_NAME,
         REP_LOAD_SESSIONS.MAPPING_NAME

FROM     
		REP_TASK_INST REP_TASK_INST,
		REP_WORKFLOW_DEP REP_WORKFLOW_DEP,
		REP_WORKFLOWS REP_WORKFLOWS,
		REP_LOAD_SESSIONS REP_LOAD_SESSIONS

WHERE    REP_TASK_INST.INSTANCE_ID=B.TO_INSTANCE_ID
AND      B.WORKFLOW_ID = REP_WORKFLOWS.WORKFLOW_ID
AND      REP_TASK_INST.TASK_ID=REP_LOAD_SESSIONS.SESSION_ID
AND      REP_WORKFLOWS.SUBJECT_AREA = 68
AND      REP_TASK_INST.TASK_TYPE=68
AND      REP_WORKFLOWS.SUBJECT_AREA='FOLDER_NAME'
GROUP BY REP_WORKFLOWS.WORKFLOW_NAME,
         REP_TASK_INST.INSTANCE_NAME,
         REP_LOAD_SESSIONS.MAPPING_ID
