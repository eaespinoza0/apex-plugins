prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_210200 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2021.10.15'
,p_release=>'21.2.0'
,p_default_workspace_id=>1824713498526400
,p_default_application_id=>126
,p_default_id_offset=>0
,p_default_owner=>'ODS'
);
end;
/
 
prompt APPLICATION 126 - Accounts Payable
--
-- Application Export:
--   Application:     126
--   Name:            Accounts Payable
--   Date and Time:   01:11 Tuesday June 21, 2022
--   Exported By:     EESPINOZA
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 304683993254351798
--   Manifest End
--   Version:         21.2.0
--   Instance ID:     248215327277049
--

begin
  -- replace components
  wwv_flow_api.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/item_type/com_vna_apex_ig_row_action
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(304683993254351798)
,p_plugin_type=>'ITEM TYPE'
,p_name=>'COM_VNA_APEX_IG_ROW_ACTION'
,p_display_name=>'VNA - Interactive Grid Row Action'
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_supported_component_types=>'APEX_APPL_PAGE_IG_COLUMNS'
,p_javascript_file_urls=>'#PLUGIN_FILES#vna_ig_row_action#MIN#.js'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'PROCEDURE render(p_item   	IN apex_plugin.t_item,',
'									 p_plugin 	IN apex_plugin.t_plugin,',
'									 p_param  	IN apex_plugin.t_item_render_param,',
'									 p_result 	IN OUT NOCOPY apex_plugin.t_item_render_result) IS',
'		l_type 				VARCHAR2(4000) :=  p_item.attribute_01;',
'    l_id					VARCHAR2(4000) :=  p_item.attribute_02;',
'    l_label				VARCHAR2(4000) :=  p_item.attribute_03;',
'    l_icon				VARCHAR2(4000) :=  p_item.attribute_04;',
'    l_icon_image	VARCHAR2(4000) :=  p_item.attribute_05;',
'    l_action_js		VARCHAR2(4000) :=  p_item.attribute_06;',
'    l_disabled		VARCHAR2(4000) :=  p_item.attribute_07;',
'    l_disabled_js	VARCHAR2(4000) :=  p_item.attribute_08;',
'    l_hide				VARCHAR2(4000) :=  p_item.attribute_09;',
'    l_hide_js			VARCHAR2(4000) :=  p_item.attribute_10;',
'',
'    l_ig_static_id 					VARCHAR2(4000);',
'    l_action_config_js 			VARCHAR2(4000);',
'    l_action_init_js				VARCHAR2(4000) := q''~VNAIGRowAction.setupRowMenu(''#IG_STATIC_ID#'', #ACTION_CONFIG_JS#);~'';',
'    l_action_ctxt_caputre		VARCHAR2(4000) := q''~VNAIGRowAction.setupRowActionContextCaptureHandler(''#IG_STATIC_ID#'');~'';',
'	BEGIN',
'    BEGIN',
'   		SELECT COALESCE(static_id, ''R''||region_id) AS ig_static_id',
'     		INTO l_ig_static_id',
'        FROM apex_application_page_regions',
'       WHERE region_id = p_item.region_id',
'         AND source_type_code = ''NATIVE_IG'';',
'    EXCEPTION',
'    	WHEN NO_DATA_FOUND THEN',
'        raise_application_error(-20001, ''VNA Interactive Grid Button can only be attached to an Interactive Grid'');  ',
'    END;',
'',
'		apex_json.initialize_clob_output;',
'',
'    apex_json.open_object;',
'    apex_json.open_array(''add'');',
'    apex_json.open_object;',
'',
'    IF l_type IS NULL THEN',
'      raise_application_error(-20001, ''Invalid Interactive Grid Row Action type, missing type'');',
'    END IF;',
'',
'    apex_json.write(''type'', l_type);',
'',
'    IF l_type != ''separator'' THEN',
'      IF l_id IS NOT NULL THEN',
'	      apex_json.write(''id'', l_id);',
'      END IF;',
'',
'      IF l_label IS NOT NULL THEN',
'        apex_json.write(''label'', l_label);',
'      END IF;',
'',
'      IF l_icon = ''Y'' THEN',
'        IF l_icon_image IS NOT NULL THEN ',
'          -- If icon is a Font APEX icon then add prefix ''fa'' for correct CSS',
'          IF REGEXP_COUNT(l_icon_image, ''^fa\-.*'') > 0 THEN',
'            l_icon_image := ''fa '' || l_icon_image;',
'          END IF; ',
'	        apex_json.write(''icon'', l_icon_image);',
'        END IF;',
'      END IF;',
'',
'      IF l_action_js IS NOT NULL THEN',
'        apex_json.write(''action'', ''#ACTION_JS#'');',
'      END IF;',
'',
'      IF l_disabled IS NOT NULL THEN',
'      	IF l_disabled != ''JS'' THEN',
'          apex_json.write(''disabled'', l_disabled = ''Y'');',
'       	ELSE',
'        	apex_json.write(''disabled'', ''#DISABLED_JS#'');',
'        END IF;',
'      END IF;',
'',
'      IF l_hide IS NOT NULL THEN',
'      	IF l_hide != ''JS'' THEN',
'          apex_json.write(''hide'', l_hide = ''Y'');',
'       	ELSE',
'        	apex_json.write(''hide'', ''#HIDE_JS#'');',
'        END IF;',
'      END IF;',
'    END IF;',
'',
'    apex_json.close_all;',
'',
'    l_action_config_js := TO_CHAR(apex_json.get_clob_output);',
'',
'    l_action_config_js := REPLACE(l_action_config_js, ''"#ACTION_JS#"'', l_action_js);',
'    l_action_config_js := REPLACE(l_action_config_js, ''"#DISABLED_JS#"'', l_disabled_js);',
'    l_action_config_js := REPLACE(l_action_config_js, ''"#HIDE_JS#"'', l_hide_js);',
'',
'		l_action_init_js := REPLACE(l_action_init_js, ''#IG_STATIC_ID#'', l_ig_static_id);',
'    l_action_init_js := REPLACE(l_action_init_js, ''#ACTION_CONFIG_JS#'', l_action_config_js);',
'',
'    l_action_ctxt_caputre := REPLACE(l_action_ctxt_caputre, ''#IG_STATIC_ID#'', l_ig_static_id);',
'',
'    apex_javascript.add_onload_code(p_code 	=> l_action_init_js, ',
'    																p_key 	=> ''VNA_IG_ROW_ACTION_INIT_JS_'' || p_item.id);',
'',
'    apex_javascript.add_onload_code(p_code 	=> l_action_ctxt_caputre, ',
'    																p_key 	=> ''VNA_IG_ROW_ACTION_CTXT_JS_'' || l_ig_static_id);',
'    apex_json.free_output;',
' 	END render;'))
,p_api_version=>2
,p_render_function=>'render'
,p_standard_attributes=>'SOURCE'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Add the below JavaScript Initialization code in the Interactive Grid''s attributes</p>',
'',
'<pre>',
'function(options) {',
'    let igStaticId = options && options.regionStaticId,',
'        toolbarData = $.apex.interactiveGrid.copyDefaultToolbar();',
'',
'    VnaIgButton.initToolbarData(igStaticId, toolbarData);   ',
'    options.initActions = function (actions) {',
'        VnaIgButton.initActions(igStaticId, actions);',
'    }',
'',
'    options.toolbarData = toolbarData;',
'',
'    return options;',
'}',
'</pre>'))
,p_version_identifier=>'0.1.0'
,p_files_version=>4
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(304685365078477745)
,p_plugin_id=>wwv_flow_api.id(304683993254351798)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Type'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'action'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(304685687293478925)
,p_plugin_attribute_id=>wwv_flow_api.id(304685365078477745)
,p_display_sequence=>10
,p_display_value=>'Action'
,p_return_value=>'action'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(304686058414479599)
,p_plugin_attribute_id=>wwv_flow_api.id(304685365078477745)
,p_display_sequence=>20
,p_display_value=>'Separator'
,p_return_value=>'separator'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(304693497705639660)
,p_plugin_id=>wwv_flow_api.id(304683993254351798)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Label'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(304685365078477745)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'NOT_EQUALS'
,p_depending_on_expression=>'separator'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(304693837234695210)
,p_plugin_id=>wwv_flow_api.id(304683993254351798)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Icon'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(304685365078477745)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'NOT_EQUALS'
,p_depending_on_expression=>'separator'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(304694164911697809)
,p_plugin_id=>wwv_flow_api.id(304683993254351798)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Icon Image/Class'
,p_attribute_type=>'ICON'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(304693837234695210)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(304699741449910258)
,p_plugin_id=>wwv_flow_api.id(304683993254351798)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Action JavaScript'
,p_attribute_type=>'JAVASCRIPT'
,p_is_required=>true
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_supported_component_types=>'APEX_APPL_PAGE_IG_COLUMNS'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(304685365078477745)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'NOT_EQUALS'
,p_depending_on_expression=>'separator'
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>',
'function (menu, element) {',
'  apex.message.alert(''Hello world!'');',
'}',
'</pre>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(304702508262211211)
,p_plugin_id=>wwv_flow_api.id(304683993254351798)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'Disabled'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'N'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(304685365078477745)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'NOT_EQUALS'
,p_depending_on_expression=>'separator'
,p_lov_type=>'STATIC'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(304702974608212313)
,p_plugin_attribute_id=>wwv_flow_api.id(304702508262211211)
,p_display_sequence=>10
,p_display_value=>'Yes'
,p_return_value=>'Y'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(304703491606212970)
,p_plugin_attribute_id=>wwv_flow_api.id(304702508262211211)
,p_display_sequence=>20
,p_display_value=>'No'
,p_return_value=>'N'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(304704116431215375)
,p_plugin_attribute_id=>wwv_flow_api.id(304702508262211211)
,p_display_sequence=>30
,p_display_value=>'JavaScript Function'
,p_return_value=>'JS'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(304704696824220132)
,p_plugin_id=>wwv_flow_api.id(304683993254351798)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>80
,p_prompt=>'Disabled - JavaScript'
,p_attribute_type=>'JAVASCRIPT'
,p_is_required=>false
,p_default_value=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function(menu){',
'  return false;',
'}'))
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_supported_component_types=>'APEX_APPL_PAGE_IG_COLUMNS'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(304702508262211211)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'JS'
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<code>',
'function(menu){',
'	return false;',
'}',
'</code>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(304714933912515080)
,p_plugin_id=>wwv_flow_api.id(304683993254351798)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>90
,p_prompt=>'Hide'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'N'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(304685365078477745)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'NOT_EQUALS'
,p_depending_on_expression=>'separator'
,p_lov_type=>'STATIC'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(304715202963515573)
,p_plugin_attribute_id=>wwv_flow_api.id(304714933912515080)
,p_display_sequence=>10
,p_display_value=>'Yes'
,p_return_value=>'Y'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(304715627229515934)
,p_plugin_attribute_id=>wwv_flow_api.id(304714933912515080)
,p_display_sequence=>20
,p_display_value=>'No'
,p_return_value=>'N'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(304716083620517511)
,p_plugin_attribute_id=>wwv_flow_api.id(304714933912515080)
,p_display_sequence=>30
,p_display_value=>'JavaScript Function'
,p_return_value=>'JS'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(304716646148526622)
,p_plugin_id=>wwv_flow_api.id(304683993254351798)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>10
,p_display_sequence=>100
,p_prompt=>'Hide - JavaScript'
,p_attribute_type=>'JAVASCRIPT'
,p_is_required=>true
,p_default_value=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function(menu){',
'  return false;',
'}'))
,p_supported_ui_types=>'DESKTOP'
,p_supported_component_types=>'APEX_APPL_PAGE_IG_COLUMNS'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(304714933912515080)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'JS'
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function(menu){',
'  return false;',
'}'))
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '636C61737320564E414947526F77416374696F6E7B0D0A09737461746963207365747570526F77416374696F6E436F6E746578744361707475726548616E646C65722869675374617469634964297B0D0A090924286023247B696753746174696349647D';
wwv_flow_api.g_varchar2_table(2) := '60292E6F6E2827636C69636B272C20602E612D427574746F6E2D2D616374696F6E735B646174612D6D656E753D22247B696753746174696349647D5F69675F726F775F616374696F6E735F6D656E75225D602C20657674203D3E207B0D0A09090977696E';
wwv_flow_api.g_varchar2_table(3) := '646F772E67566E61526F77416374696F6E436F6E74657874203D206576742E63757272656E745461726765743B0D0A09097D293B0D0A097D0D0A0D0A09737461746963207365747570526F774D656E7528696753746174696349642C206F707473297B0D';
wwv_flow_api.g_varchar2_table(4) := '0A0D0A09096966282169675374617469634964297B0D0A090909617065782E64656275672E7761726E28274E6F204947205374617469632049442070726F766964656420666F7220616374696F6E732068616E646C696E6720736574757027293B0D0A09';
wwv_flow_api.g_varchar2_table(5) := '090972657475726E3B0D0A09097D0D0A0D0A09092428206023247B696753746174696349647D6020292E6F6E282027696E74657261637469766567726964766965776368616E6765272C2066756E6374696F6E28206576656E742C20646174612029207B';
wwv_flow_api.g_varchar2_table(6) := '0D0A0909096C65742076696577203D20617065782E726567696F6E28696753746174696349642920262620617065782E726567696F6E2869675374617469634964292E7769646765742829202626200D0A0909090909090909617065782E726567696F6E';
wwv_flow_api.g_varchar2_table(7) := '2869675374617469634964292E77696467657428292E696E7465726163746976654772696428226765745669657773222C20226772696422292C0D0A09090909096D656E7524203D207669657720262620766965772E726F77416374696F6E4D656E7524';
wwv_flow_api.g_varchar2_table(8) := '2C0D0A0909090909616374696F6E73203D2020617065782E726567696F6E28696753746174696349642920262620617065782E726567696F6E2869675374617469634964292E7769646765742829202626200D0A09090909090909090909617065782E72';
wwv_flow_api.g_varchar2_table(9) := '6567696F6E2869675374617469634964292E77696467657428292E696E746572616374697665477269642822676574416374696F6E7322292C0D0A0909090909616374696F6E73416464203D206F707473202626206F7074732E616464207C7C205B5D2C';
wwv_flow_api.g_varchar2_table(10) := '0D0A0909090909616374696F6E7352656D6F7665203D206F707473202626206F7074732E72656D6F7665207C7C205B5D2C0D0A0909090909616374696F6E7344697361626C65203D206F707473202626206F7074732E64697361626C65207C7C205B5D3B';
wwv_flow_api.g_varchar2_table(11) := '0D0A0D0A090909666F7228206C65742069203D20303B2069203C20616374696F6E734164642E6C656E6774683B20692B2B297B0D0A090909096C6574206F7074696F6E73203D206D656E75242E6D656E7528226F7074696F6E22292E6974656D733B0D0A';
wwv_flow_api.g_varchar2_table(12) := '090909096C657420657869737473203D2066616C73653B0D0A09090909666F7220286C65742078203D2030203B2078203C206F7074696F6E732E6C656E6774683B20782B2B297B0D0A0909090909696620286F7074696F6E735B785D2E6C6162656C203D';
wwv_flow_api.g_varchar2_table(13) := '3D20616374696F6E734164645B695D2E6C6162656C20262620616374696F6E734164645B695D2E74797065203D3D2027616374696F6E27297B0D0A090909090909657869737473203D20747275653B0D0A09090909097D0D0A090909097D0D0A09090909';
wwv_flow_api.g_varchar2_table(14) := '6966202821657869737473297B0D0A09090909096D656E75242E6D656E7528226F7074696F6E22292E6974656D732E7075736828616374696F6E734164645B695D293B0D0A090909097D0D0A0909097D0D0A0D0A090909666F7228206C65742069203D20';
wwv_flow_api.g_varchar2_table(15) := '303B2069203C20616374696F6E7352656D6F76652E6C656E6774683B20692B2B297B0D0A09090909616374696F6E732E72656D6F766528616374696F6E7352656D6F76655B695D293B0D0A0909097D0D0A0D0A090909666F7228206C65742069203D2030';
wwv_flow_api.g_varchar2_table(16) := '3B2069203C20616374696F6E7344697361626C652E6C656E6774683B20692B2B297B0D0A09090909616374696F6E732E64697361626C6528616374696F6E7344697361626C655B695D293B0D0A0909097D0D0A09097D293B0D0A097D0D0A7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(159889709067795823)
,p_plugin_id=>wwv_flow_api.id(304683993254351798)
,p_file_name=>'vna_ig_row_action.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '636C61737320564E414947526F77416374696F6E7B737461746963207365747570526F77416374696F6E436F6E746578744361707475726548616E646C65722865297B24286023247B657D60292E6F6E2822636C69636B222C602E612D427574746F6E2D';
wwv_flow_api.g_varchar2_table(2) := '2D616374696F6E735B646174612D6D656E753D22247B657D5F69675F726F775F616374696F6E735F6D656E75225D602C28653D3E7B77696E646F772E67566E61526F77416374696F6E436F6E746578743D652E63757272656E745461726765747D29297D';
wwv_flow_api.g_varchar2_table(3) := '737461746963207365747570526F774D656E7528652C74297B653F24286023247B657D60292E6F6E2822696E74657261637469766567726964766965776368616E6765222C2866756E6374696F6E28692C6E297B6C6574206F3D617065782E726567696F';
wwv_flow_api.g_varchar2_table(4) := '6E2865292626617065782E726567696F6E2865292E77696467657428292626617065782E726567696F6E2865292E77696467657428292E696E7465726163746976654772696428226765745669657773222C226772696422292C613D6F26266F2E726F77';
wwv_flow_api.g_varchar2_table(5) := '416374696F6E4D656E75242C723D617065782E726567696F6E2865292626617065782E726567696F6E2865292E77696467657428292626617065782E726567696F6E2865292E77696467657428292E696E74657261637469766547726964282267657441';
wwv_flow_api.g_varchar2_table(6) := '6374696F6E7322292C673D742626742E6164647C7C5B5D2C633D742626742E72656D6F76657C7C5B5D2C6C3D742626742E64697361626C657C7C5B5D3B666F72286C657420653D303B653C672E6C656E6774683B652B2B297B6C657420743D612E6D656E';
wwv_flow_api.g_varchar2_table(7) := '7528226F7074696F6E22292E6974656D732C693D21313B666F72286C6574206E3D303B6E3C742E6C656E6774683B6E2B2B29745B6E5D2E6C6162656C3D3D675B655D2E6C6162656C262622616374696F6E223D3D675B655D2E74797065262628693D2130';
wwv_flow_api.g_varchar2_table(8) := '293B697C7C612E6D656E7528226F7074696F6E22292E6974656D732E7075736828675B655D297D666F72286C657420653D303B653C632E6C656E6774683B652B2B29722E72656D6F766528635B655D293B666F72286C657420653D303B653C6C2E6C656E';
wwv_flow_api.g_varchar2_table(9) := '6774683B652B2B29722E64697361626C65286C5B655D297D29293A617065782E64656275672E7761726E28224E6F204947205374617469632049442070726F766964656420666F7220616374696F6E732068616E646C696E6720736574757022297D7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(159890558570796161)
,p_plugin_id=>wwv_flow_api.id(304683993254351798)
,p_file_name=>'vna_ig_row_action.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
prompt --application/end_environment
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done
