/* run as APEX_yourversion */
CREATE OR REPLACE PROCEDURE SET_INSTANCE_BANNER(p_js_filepath IN VARCHAR2, p_old_js_filepath IN VARCHAR2 DEFAULT NULL) AS 
  l_new_js_code VARCHAR2(4000) := 
    'apex.jQuery("body").prepend(''<script type="text/javascript" src="'|| p_js_filepath ||'">'');';
  l_old_js_code VARCHAR2(4000) := 
    'apex.jQuery("body").prepend(''<script type="text/javascript" src="'|| p_old_js_filepath ||'">'');';
BEGIN
-- this procedure goes into the wwv_flow_templates table and updates the javascript_code_onload field for APEX IDE pages
-- p_js_filepath should be a filename of a javascript file on the server that needs to execute on each page load of the ide
-- if p_old_js_filepath is provided, it will be removed

  if p_old_js_filepath is not null then
    update wwv_flow_templates
       set javascript_code_onload = replace(javascript_code_onload, l_old_js_code, '')
     where flow_id in (4000, 4050, 4500, 4550) and is_popup = 'N';
  end if;

  if p_js_filepath is not null then
    update wwv_flow_templates
       set javascript_code_onload = l_new_js_code || javascript_code_onload
     WHERE flow_id in (4000, 4050, 4500, 4550) and is_popup = 'N';
  end if;
  
END SET_INSTANCE_BANNER;
