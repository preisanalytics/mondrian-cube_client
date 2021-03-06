require 'spec_helper'
require_relative '../../../../lib/mondrian/cube_client/connection'
require 'byebug'
require 'mondrian/cube_client/connection'

RSPEC_TEST_URL='http://localhost_sample:8080'
RSpec.describe Mondrian::CubeClient do

  let(:cubedefinition) {
    File.read(RSPEC_APP_PATH.join('fixtures', 'cube_definition.xml'))
  }
  let(:connection) {
    # Mondrian::CubeClient.connection( RSPEC_TEST_URL + "/mondrian/keepalive.html")
    conn_mock_obj = instance_double("Mondrian::CubeClient::Connection", :base_url => "http://local+host_sample:8080")
    # byebug
    # allow_any_instance_of(Mondrian::CubeClient::Connection).to receive(:base_url => "http://localhost_sample:8080")
    uri = URI("http://validurl:8080")
    allow(URI).to receive(:parse).and_return(uri)
    Mondrian::CubeClient::Connection.new(RSPEC_TEST_URL)
  }

  let(:success_reponse) { "<output><Catalog name=\"mycat\" datasourceinfo=\"JdbcDrivers=com.mysql.jdbc.Driver;
Provider=Mondrian;
Jdbc=jdbc:mysql://localhost:3306/foodmart?user=foodmart&#38;password=temp;Catalog=file://var/lib/tomcat7/webapps/mondrian/WEB-INF/queries/catalog_name.xml;\"><Cube name=\"mycube\"> <Dimension foreignKey=\"customer_id\" name=\"Gender\">    <Hierarchy allMemberName=\"All Gender\" hasAll=\"true\" primaryKey=\"customer_id\">      <Table name=\"customer\"/>      <Level column=\"gender\" name=\"Gender\" uniqueMembers=\"true\"/>    </Hierarchy>  </Dimension></Cube></Catalog></output>" }

  let(:success_multiple_cubes_reponse) { "<output><Catalog name=\"mycat\" datasourceinfo=\"JdbcDrivers=org.postgresql.Driver;Provider=Mondrian;Jdbc=jdbc:postgresql://localhost:5432/foodmart?user=postgres&#38;password=password;Catalog=file:/var/lib/tomcat7/webapps/mondrian/WEB-INF/queries/FoodMart.xml;\"><Cube defaultMeasure=\"Unit Sales\" name=\"Sales\">  <!-- Use annotations to provide translations of this cube's caption and       description into German and French. Use of annotations in this manner is       experimental and unsupported; just for testing right now. -->  <Annotations>    <Annotation name=\"caption.de_DE\">Verkaufen</Annotation>    <Annotation name=\"caption.fr_FR\">Ventes</Annotation>    <Annotation name=\"description.fr_FR\">Cube des ventes</Annotation>    <Annotation name=\"description.de\">Cube Verkaufen</Annotation>    <Annotation name=\"description.de_AT\">Cube den Verkaufen</Annotation>  </Annotations>  <Table name=\"sales_fact_1997\"><!--    <AggExclude name=\"agg_l_03_sales_fact_1997\" />    <AggExclude name=\"agg_ll_01_sales_fact_1997\" />    <AggExclude name=\"agg_pl_01_sales_fact_1997\" />    <AggExclude name=\"agg_l_05_sales_fact_1997\" />-->    <AggExclude name=\"agg_c_special_sales_fact_1997\"/><!--    <AggExclude name=\"agg_c_14_sales_fact_1997\" />-->    <AggExclude name=\"agg_lc_100_sales_fact_1997\"/>    <AggExclude name=\"agg_lc_10_sales_fact_1997\"/>    <AggExclude name=\"agg_pc_10_sales_fact_1997\"/>    <AggName name=\"agg_c_special_sales_fact_1997\">        <AggFactCount column=\"FACT_COUNT\"/>        <AggIgnoreColumn column=\"foo\"/>        <AggIgnoreColumn column=\"bar\"/>        <AggForeignKey aggColumn=\"PRODUCT_ID\" factColumn=\"product_id\"/>        <AggForeignKey aggColumn=\"CUSTOMER_ID\" factColumn=\"customer_id\"/>        <AggForeignKey aggColumn=\"PROMOTION_ID\" factColumn=\"promotion_id\"/>        <AggForeignKey aggColumn=\"STORE_ID\" factColumn=\"store_id\"/><!--        <AggMeasure name=\"[Measures].[Avg Unit Sales]\" column=\"UNIT_SALES_AVG\"/>-->        <AggMeasure column=\"UNIT_SALES_SUM\" name=\"[Measures].[Unit Sales]\"/>        <AggMeasure column=\"STORE_COST_SUM\" name=\"[Measures].[Store Cost]\"/>        <AggMeasure column=\"STORE_SALES_SUM\" name=\"[Measures].[Store Sales]\"/>        <AggLevel column=\"TIME_YEAR\" name=\"[Time].[Year]\"/>        <AggLevel column=\"TIME_QUARTER\" name=\"[Time].[Quarter]\"/>        <AggLevel column=\"TIME_MONTH\" name=\"[Time].[Month]\"/>    </AggName>  </Table>  <DimensionUsage foreignKey=\"store_id\" name=\"Store\" source=\"Store\"/>  <DimensionUsage foreignKey=\"store_id\" name=\"Store Size in SQFT\" source=\"Store Size in SQFT\"/>  <DimensionUsage foreignKey=\"store_id\" name=\"Store Type\" source=\"Store Type\"/>  <DimensionUsage foreignKey=\"time_id\" name=\"Time\" source=\"Time\"/>  <DimensionUsage foreignKey=\"product_id\" name=\"Product\" source=\"Product\"/>  <Dimension foreignKey=\"promotion_id\" name=\"Promotion Media\">    <Hierarchy allMemberName=\"All Media\" defaultMember=\"All Media\" hasAll=\"true\" primaryKey=\"promotion_id\">      <Table name=\"promotion\"/>      <Level column=\"media_type\" name=\"Media Type\" uniqueMembers=\"true\"/>    </Hierarchy>  </Dimension>  <Dimension foreignKey=\"promotion_id\" name=\"Promotions\">    <Hierarchy allMemberName=\"All Promotions\" defaultMember=\"[All Promotions]\" hasAll=\"true\" primaryKey=\"promotion_id\">      <Table name=\"promotion\"/>      <Level column=\"promotion_name\" name=\"Promotion Name\" uniqueMembers=\"true\"/>    </Hierarchy>  </Dimension>  <Dimension foreignKey=\"customer_id\" name=\"Customers\">    <Hierarchy allMemberName=\"All Customers\" hasAll=\"true\" primaryKey=\"customer_id\">      <Table name=\"customer\"/>      <Level column=\"country\" name=\"Country\" uniqueMembers=\"true\"/>      <Level column=\"state_province\" name=\"State Province\" uniqueMembers=\"true\"/>      <Level column=\"city\" name=\"City\" uniqueMembers=\"false\"/>      <Level column=\"customer_id\" name=\"Name\" type=\"Numeric\" uniqueMembers=\"true\">        <NameExpression>          <SQL dialect=\"oracle\">\"fname\" || ' ' || \"lname\"          </SQL>          <SQL dialect=\"hive\">`customer`.`fullname`          </SQL>          <SQL dialect=\"hsqldb\">\"fname\" || ' ' || \"lname\"          </SQL>          <SQL dialect=\"access\">fname + ' ' + lname          </SQL>          <SQL dialect=\"postgres\">\"fname\" || ' ' || \"lname\"          </SQL>          <SQL dialect=\"mysql\">CONCAT(`customer`.`fname`, ' ', `customer`.`lname`)          </SQL>          <SQL dialect=\"mssql\">fname + ' ' + lname          </SQL>          <SQL dialect=\"derby\">\"customer\".\"fullname\"          </SQL>          <SQL dialect=\"db2\">CONCAT(CONCAT(\"customer\".\"fname\", ' '), \"customer\".\"lname\")          </SQL>          <SQL dialect=\"luciddb\">\"fname\" || ' ' || \"lname\"          </SQL>          <SQL dialect=\"neoview\">\"customer\".\"fullname\"          </SQL>          <SQL dialect=\"teradata\">\"fname\" || ' ' || \"lname\"          </SQL>          <SQL dialect=\"generic\">fullname          </SQL>        </NameExpression>        <OrdinalExpression>          <SQL dialect=\"oracle\">\"fname\" || ' ' || \"lname\"          </SQL>          <SQL dialect=\"hsqldb\">\"fname\" || ' ' || \"lname\"          </SQL>          <SQL dialect=\"access\">fname + ' ' + lname          </SQL>          <SQL dialect=\"postgres\">\"fname\" || ' ' || \"lname\"          </SQL>          <SQL dialect=\"mysql\">CONCAT(`customer`.`fname`, ' ', `customer`.`lname`)          </SQL>          <SQL dialect=\"mssql\">fname + ' ' + lname          </SQL>          <SQL dialect=\"neoview\">\"customer\".\"fullname\"          </SQL>          <SQL dialect=\"derby\">\"customer\".\"fullname\"          </SQL>          <SQL dialect=\"db2\">CONCAT(CONCAT(\"customer\".\"fname\", ' '), \"customer\".\"lname\")          </SQL>          <SQL dialect=\"luciddb\">\"fname\" || ' ' || \"lname\"          </SQL>          <SQL dialect=\"generic\">fullname          </SQL>        </OrdinalExpression>        <Property column=\"gender\" name=\"Gender\"/>        <Property column=\"marital_status\" name=\"Marital Status\"/>        <Property column=\"education\" name=\"Education\"/>        <Property column=\"yearly_income\" name=\"Yearly Income\"/>      </Level>    </Hierarchy>  </Dimension>  <Dimension foreignKey=\"customer_id\" name=\"Education Level\">    <Hierarchy hasAll=\"true\" primaryKey=\"customer_id\">      <Table name=\"customer\"/>      <Level column=\"education\" name=\"Education Level\" uniqueMembers=\"true\"/>    </Hierarchy>  </Dimension>  <Dimension foreignKey=\"customer_id\" name=\"Gender\">    <Hierarchy allMemberName=\"All Gender\" hasAll=\"true\" primaryKey=\"customer_id\">      <Table name=\"customer\"/>      <Level column=\"gender\" name=\"Gender\" uniqueMembers=\"true\"/>    </Hierarchy>  </Dimension>  <Dimension foreignKey=\"customer_id\" name=\"Marital Status\">    <Hierarchy allMemberName=\"All Marital Status\" hasAll=\"true\" primaryKey=\"customer_id\">      <Table name=\"customer\"/>      <Level approxRowCount=\"111\" column=\"marital_status\" name=\"Marital Status\" uniqueMembers=\"true\"/>    </Hierarchy>  </Dimension>  <Dimension foreignKey=\"customer_id\" name=\"Yearly Income\">    <Hierarchy hasAll=\"true\" primaryKey=\"customer_id\">      <Table name=\"customer\"/>      <Level column=\"yearly_income\" name=\"Yearly Income\" uniqueMembers=\"true\"/>    </Hierarchy>  </Dimension>  <Measure aggregator=\"sum\" column=\"unit_sales\" formatString=\"Standard\" name=\"Unit Sales\"/>  <Measure aggregator=\"sum\" column=\"store_cost\" formatString=\"#,###.00\" name=\"Store Cost\"/>  <Measure aggregator=\"sum\" column=\"store_sales\" formatString=\"#,###.00\" name=\"Store Sales\"/>  <Measure aggregator=\"count\" column=\"product_id\" formatString=\"#,###\" name=\"Sales Count\"/>  <Measure aggregator=\"distinct-count\" column=\"customer_id\" formatString=\"#,###\" name=\"Customer Count\"/>  <Measure aggregator=\"sum\" formatString=\"#,###.00\" name=\"Promotion Sales\">    <MeasureExpression>      <SQL dialect=\"access\">Iif(\"sales_fact_1997\".\"promotion_id\" = 0, 0, \"sales_fact_1997\".\"store_sales\")      </SQL>      <SQL dialect=\"oracle\">(case when \"sales_fact_1997\".\"promotion_id\" = 0 then 0 else \"sales_fact_1997\".\"store_sales\" end)      </SQL>      <SQL dialect=\"hsqldb\">(case when \"sales_fact_1997\".\"promotion_id\" = 0 then 0 else \"sales_fact_1997\".\"store_sales\" end)      </SQL>      <SQL dialect=\"postgres\">(case when \"sales_fact_1997\".\"promotion_id\" = 0 then 0 else \"sales_fact_1997\".\"store_sales\" end)      </SQL>      <SQL dialect=\"mysql\">(case when `sales_fact_1997`.`promotion_id` = 0 then 0 else `sales_fact_1997`.`store_sales` end)      </SQL>      <!-- Workaround the fact that Infobright does not have a CASE operator.           The simpler expression gives wrong results, so some tests are           disabled. -->      <SQL dialect=\"neoview\">(case when \"sales_fact_1997\".\"promotion_id\" = 0 then 0 else \"sales_fact_1997\".\"store_sales\" end)      </SQL>      <SQL dialect=\"infobright\">`sales_fact_1997`.`store_sales`      </SQL>      <SQL dialect=\"derby\">(case when \"sales_fact_1997\".\"promotion_id\" = 0 then 0 else \"sales_fact_1997\".\"store_sales\" end)      </SQL>      <SQL dialect=\"luciddb\">(case when \"sales_fact_1997\".\"promotion_id\" = 0 then 0 else \"sales_fact_1997\".\"store_sales\" end)      </SQL>      <SQL dialect=\"db2\">(case when \"sales_fact_1997\".\"promotion_id\" = 0 then 0 else \"sales_fact_1997\".\"store_sales\" end)      </SQL>      <SQL dialect=\"nuodb\">(case when \"sales_fact_1997\".\"promotion_id\" = 0 then 0 else \"sales_fact_1997\".\"store_sales\" end)      </SQL>      <SQL dialect=\"generic\">(case when sales_fact_1997.promotion_id = 0 then 0 else sales_fact_1997.store_sales end)      </SQL>    </MeasureExpression>  </Measure>  <CalculatedMember dimension=\"Measures\" name=\"Profit\">    <Formula>[Measures].[Store Sales] - [Measures].[Store Cost]</Formula>    <CalculatedMemberProperty name=\"FORMAT_STRING\" value=\"$#,##0.00\"/>  </CalculatedMember>  <CalculatedMember dimension=\"Measures\" formula=\"COALESCEEMPTY((Measures.[Profit], [Time].[Time].PREVMEMBER),    Measures.[Profit])\" name=\"Profit last Period\" visible=\"false\">    <CalculatedMemberProperty name=\"FORMAT_STRING\" value=\"$#,##0.00\"/>    <CalculatedMemberProperty name=\"MEMBER_ORDINAL\" value=\"18\"/>  </CalculatedMember>  <CalculatedMember caption=\"Gewinn-Wachstum\" dimension=\"Measures\" formula=\"([Measures].[Profit] - [Measures].[Profit last Period]) / [Measures].[Profit last Period]\" name=\"Profit Growth\" visible=\"true\">    <CalculatedMemberProperty name=\"FORMAT_STRING\" value=\"0.0%\"/>  </CalculatedMember></Cube><Cube name=\"Warehouse\">  <Table name=\"inventory_fact_1997\"/>  <DimensionUsage foreignKey=\"store_id\" name=\"Store\" source=\"Store\"/>  <DimensionUsage foreignKey=\"store_id\" name=\"Store Size in SQFT\" source=\"Store Size in SQFT\"/>  <DimensionUsage foreignKey=\"store_id\" name=\"Store Type\" source=\"Store Type\"/>  <DimensionUsage foreignKey=\"time_id\" name=\"Time\" source=\"Time\"/>  <DimensionUsage foreignKey=\"product_id\" name=\"Product\" source=\"Product\"/>  <DimensionUsage foreignKey=\"warehouse_id\" name=\"Warehouse\" source=\"Warehouse\"/>  <Measure aggregator=\"sum\" column=\"store_invoice\" name=\"Store Invoice\"/>  <Measure aggregator=\"sum\" column=\"supply_time\" name=\"Supply Time\"/>  <Measure aggregator=\"sum\" column=\"warehouse_cost\" name=\"Warehouse Cost\"/>  <Measure aggregator=\"sum\" column=\"warehouse_sales\" name=\"Warehouse Sales\"/>  <Measure aggregator=\"sum\" column=\"units_shipped\" formatString=\"#.0\" name=\"Units Shipped\"/>  <Measure aggregator=\"sum\" column=\"units_ordered\" formatString=\"#.0\" name=\"Units Ordered\"/>  <Measure aggregator=\"sum\" name=\"Warehouse Profit\">    <MeasureExpression>      <SQL dialect=\"mysql\">`warehouse_sales` - `inventory_fact_1997`.`warehouse_cost`      </SQL>      <SQL dialect=\"infobright\">`warehouse_sales` - `inventory_fact_1997`.`warehouse_cost`      </SQL>      <SQL dialect=\"generic\">\"warehouse_sales\" - \"inventory_fact_1997\".\"warehouse_cost\"      </SQL>    </MeasureExpression>  </Measure>  <CalculatedMember dimension=\"Measures\" name=\"Average Warehouse Sale\">    <Formula>[Measures].[Warehouse Sales] / [Measures].[Warehouse Cost]</Formula>    <CalculatedMemberProperty name=\"FORMAT_STRING\" value=\"$#,##0.00\"/>  </CalculatedMember>  <NamedSet name=\"Top Sellers\">    <Formula>TopCount([Warehouse].[Warehouse Name].MEMBERS, 5, [Measures].[Warehouse Sales])</Formula>  </NamedSet>    </Cube><Cube name=\"Store\">  <Table name=\"store\"/>  <!-- We could have used the shared dimension \"Store Type\", but we     want to test private dimensions without primary key. -->  <Dimension name=\"Store Type\">    <Hierarchy hasAll=\"true\">      <Level column=\"store_type\" name=\"Store Type\" uniqueMembers=\"true\"/>    </Hierarchy>  </Dimension>  <!-- We don't have to specify primary key or foreign key since the shared     dimension \"Store\" has the same underlying table as the cube. -->  <DimensionUsage name=\"Store\" source=\"Store\"/>  <Dimension name=\"Has coffee bar\">    <Hierarchy hasAll=\"true\">      <Level column=\"coffee_bar\" name=\"Has coffee bar\" type=\"Boolean\" uniqueMembers=\"true\"/>    </Hierarchy>  </Dimension>  <Measure aggregator=\"sum\" column=\"store_sqft\" formatString=\"#,###\" name=\"Store Sqft\"/>  <Measure aggregator=\"sum\" column=\"grocery_sqft\" formatString=\"#,###\" name=\"Grocery Sqft\"/></Cube><Cube name=\"HR\">  <Table name=\"salary\"/>  <!-- Use private \"Time\" dimension because key is different than public     \"Time\" dimension. -->  <Dimension foreignKey=\"pay_date\" name=\"Time\" type=\"TimeDimension\">    <Hierarchy hasAll=\"false\" primaryKey=\"the_date\">      <Table name=\"time_by_day\"/>      <Level column=\"the_year\" levelType=\"TimeYears\" name=\"Year\" type=\"Numeric\" uniqueMembers=\"true\"/>      <Level column=\"quarter\" levelType=\"TimeQuarters\" name=\"Quarter\" uniqueMembers=\"false\"/>      <!-- Use the_month as source for the name, so members look like           [Time].[1997].[Q1].[Jan] rather than [Time].[1997].[Q1].[1]. -->      <Level column=\"month_of_year\" levelType=\"TimeMonths\" name=\"Month\" nameColumn=\"the_month\" type=\"Numeric\" uniqueMembers=\"false\"/>    </Hierarchy>  </Dimension>  <Dimension foreignKey=\"employee_id\" name=\"Store\">    <Hierarchy hasAll=\"true\" primaryKey=\"employee_id\" primaryKeyTable=\"employee\">      <Join leftKey=\"store_id\" rightKey=\"store_id\">        <Table name=\"employee\"/>        <Table name=\"store\"/>      </Join>      <Level column=\"store_country\" name=\"Store Country\" table=\"store\" uniqueMembers=\"true\"/>      <Level column=\"store_state\" name=\"Store State\" table=\"store\" uniqueMembers=\"true\"/>      <Level column=\"store_city\" name=\"Store City\" table=\"store\" uniqueMembers=\"false\"/>      <Level column=\"store_name\" name=\"Store Name\" table=\"store\" uniqueMembers=\"true\">        <Property column=\"store_type\" name=\"Store Type\"/>        <Property column=\"store_manager\" name=\"Store Manager\"/>        <Property column=\"store_sqft\" name=\"Store Sqft\" type=\"Numeric\"/>        <Property column=\"grocery_sqft\" name=\"Grocery Sqft\" type=\"Numeric\"/>        <Property column=\"frozen_sqft\" name=\"Frozen Sqft\" type=\"Numeric\"/>        <Property column=\"meat_sqft\" name=\"Meat Sqft\" type=\"Numeric\"/>        <Property column=\"coffee_bar\" name=\"Has coffee bar\" type=\"Boolean\"/>        <Property column=\"store_street_address\" name=\"Street address\" type=\"String\"/>      </Level>    </Hierarchy>  </Dimension>  <Dimension foreignKey=\"employee_id\" name=\"Pay Type\">    <Hierarchy hasAll=\"true\" primaryKey=\"employee_id\" primaryKeyTable=\"employee\">      <Join leftKey=\"position_id\" rightKey=\"position_id\">        <Table name=\"employee\"/>        <Table name=\"position\"/>      </Join>      <Level column=\"pay_type\" name=\"Pay Type\" table=\"position\" uniqueMembers=\"true\"/>    </Hierarchy>  </Dimension>  <Dimension foreignKey=\"employee_id\" name=\"Store Type\">    <Hierarchy hasAll=\"true\" primaryKey=\"employee_id\" primaryKeyTable=\"employee\">      <Join leftKey=\"store_id\" rightKey=\"store_id\">        <Table name=\"employee\"/>        <Table name=\"store\"/>      </Join>      <Level column=\"store_type\" name=\"Store Type\" table=\"store\" uniqueMembers=\"true\"/>    </Hierarchy>  </Dimension>  <Dimension foreignKey=\"employee_id\" name=\"Position\">    <Hierarchy allMemberName=\"All Position\" hasAll=\"true\" primaryKey=\"employee_id\">      <Table name=\"employee\"/>      <Level column=\"management_role\" name=\"Management Role\" uniqueMembers=\"true\"/>      <Level column=\"position_title\" name=\"Position Title\" ordinalColumn=\"position_id\" uniqueMembers=\"false\"/>    </Hierarchy>  </Dimension>  <Dimension foreignKey=\"department_id\" name=\"Department\">    <Hierarchy hasAll=\"true\" primaryKey=\"department_id\">      <Table name=\"department\"/>      <Level column=\"department_id\" name=\"Department Description\" type=\"Numeric\" uniqueMembers=\"true\"/>    </Hierarchy>  </Dimension>  <Dimension foreignKey=\"employee_id\" name=\"Employees\">    <Hierarchy allMemberName=\"All Employees\" hasAll=\"true\" primaryKey=\"employee_id\">      <Table name=\"employee\"/>      <Level column=\"employee_id\" name=\"Employee Id\" nameColumn=\"full_name\" nullParentValue=\"0\" parentColumn=\"supervisor_id\" type=\"Numeric\" uniqueMembers=\"true\">        <Closure childColumn=\"employee_id\" parentColumn=\"supervisor_id\">          <Table name=\"employee_closure\"/>        </Closure>        <Property column=\"marital_status\" name=\"Marital Status\"/>        <Property column=\"position_title\" name=\"Position Title\"/>        <Property column=\"gender\" name=\"Gender\"/>        <Property column=\"salary\" name=\"Salary\"/>        <Property column=\"education_level\" name=\"Education Level\"/>        <Property column=\"management_role\" name=\"Management Role\"/>      </Level>    </Hierarchy>  </Dimension>  <Measure aggregator=\"sum\" column=\"salary_paid\" formatString=\"Currency\" name=\"Org Salary\"/>  <Measure aggregator=\"count\" column=\"employee_id\" formatString=\"#,#\" name=\"Count\"/>  <Measure aggregator=\"distinct-count\" column=\"employee_id\" formatString=\"#,#\" name=\"Number of Employees\"/>  <CalculatedMember dimension=\"Measures\" formatString=\"Currency\" formula=\"([Employees].currentmember.datamember, [Measures].[Org Salary])\" name=\"Employee Salary\"/>  <CalculatedMember dimension=\"Measures\" formatString=\"Currency\" formula=\"[Measures].[Org Salary]/[Measures].[Number of Employees]\" name=\"Avg Salary\"/></Cube><Cube name=\"Sales Ragged\">  <Table name=\"sales_fact_1997\">    <AggExclude name=\"agg_pc_10_sales_fact_1997\"/>    <AggExclude name=\"agg_lc_10_sales_fact_1997\"/>  </Table>  <Dimension foreignKey=\"store_id\" name=\"Store\">    <Hierarchy hasAll=\"true\" primaryKey=\"store_id\">      <Table name=\"store_ragged\"/>      <Level column=\"store_country\" hideMemberIf=\"Never\" name=\"Store Country\" uniqueMembers=\"true\"/>      <Level column=\"store_state\" hideMemberIf=\"IfParentsName\" name=\"Store State\" uniqueMembers=\"true\"/>      <Level column=\"store_city\" hideMemberIf=\"IfBlankName\" name=\"Store City\" uniqueMembers=\"false\"/>      <Level column=\"store_name\" hideMemberIf=\"Never\" name=\"Store Name\" uniqueMembers=\"true\">        <Property column=\"store_type\" name=\"Store Type\"/>        <Property column=\"store_manager\" name=\"Store Manager\"/>        <Property column=\"store_sqft\" name=\"Store Sqft\" type=\"Numeric\"/>        <Property column=\"grocery_sqft\" name=\"Grocery Sqft\" type=\"Numeric\"/>        <Property column=\"frozen_sqft\" name=\"Frozen Sqft\" type=\"Numeric\"/>        <Property column=\"meat_sqft\" name=\"Meat Sqft\" type=\"Numeric\"/>        <Property column=\"coffee_bar\" name=\"Has coffee bar\" type=\"Boolean\"/>        <Property column=\"store_street_address\" name=\"Street address\" type=\"String\"/>      </Level>    </Hierarchy>  </Dimension>  <Dimension foreignKey=\"store_id\" name=\"Geography\">    <Hierarchy hasAll=\"true\" primaryKey=\"store_id\">      <Table name=\"store_ragged\"/>      <Level column=\"store_country\" hideMemberIf=\"Never\" name=\"Country\" uniqueMembers=\"true\"/>      <Level column=\"store_state\" hideMemberIf=\"IfParentsName\" name=\"State\" uniqueMembers=\"true\"/>      <Level column=\"store_city\" hideMemberIf=\"IfBlankName\" name=\"City\" uniqueMembers=\"false\"/>    </Hierarchy>  </Dimension>  <DimensionUsage foreignKey=\"store_id\" name=\"Store Size in SQFT\" source=\"Store Size in SQFT\"/>  <DimensionUsage foreignKey=\"store_id\" name=\"Store Type\" source=\"Store Type\"/>  <DimensionUsage foreignKey=\"time_id\" name=\"Time\" source=\"Time\"/>  <DimensionUsage foreignKey=\"product_id\" name=\"Product\" source=\"Product\"/>  <Dimension foreignKey=\"promotion_id\" name=\"Promotion Media\">    <Hierarchy allMemberName=\"All Media\" hasAll=\"true\" primaryKey=\"promotion_id\">      <Table name=\"promotion\"/>      <Level column=\"media_type\" name=\"Media Type\" uniqueMembers=\"true\"/>    </Hierarchy>  </Dimension>  <Dimension foreignKey=\"promotion_id\" name=\"Promotions\">    <Hierarchy allMemberName=\"All Promotions\" hasAll=\"true\" primaryKey=\"promotion_id\">      <Table name=\"promotion\"/>      <Level column=\"promotion_name\" name=\"Promotion Name\" uniqueMembers=\"true\"/>    </Hierarchy>  </Dimension>  <Dimension foreignKey=\"customer_id\" name=\"Customers\">    <Hierarchy allMemberName=\"All Customers\" hasAll=\"true\" primaryKey=\"customer_id\">      <Table name=\"customer\"/>      <Level column=\"country\" name=\"Country\" uniqueMembers=\"true\"/>      <Level column=\"state_province\" name=\"State Province\" uniqueMembers=\"true\"/>      <Level column=\"city\" name=\"City\" uniqueMembers=\"false\"/>      <Level name=\"Name\" uniqueMembers=\"true\">        <KeyExpression>          <SQL dialect=\"oracle\">\"fname\" || ' ' || \"lname\"          </SQL>          <SQL dialect=\"hsqldb\">\"fname\" || ' ' || \"lname\"          </SQL>          <SQL dialect=\"access\">fname + ' ' + lname          </SQL>          <SQL dialect=\"postgres\">\"fname\" || ' ' || \"lname\"          </SQL>          <SQL dialect=\"mysql\">CONCAT(`customer`.`fname`, ' ', `customer`.`lname`)          </SQL>          <SQL dialect=\"mssql\">fname + ' ' + lname          </SQL>          <SQL dialect=\"derby\">\"customer\".\"fullname\"          </SQL>          <SQL dialect=\"db2\">CONCAT(CONCAT(\"customer\".\"fname\", ' '), \"customer\".\"lname\")          </SQL>          <SQL dialect=\"luciddb\">\"fname\" || ' ' || \"lname\"          </SQL>          <SQL dialect=\"neoview\">\"customer\".\"fullname\"          </SQL>          <SQL dialect=\"generic\">fullname          </SQL>        </KeyExpression>        <Property column=\"gender\" name=\"Gender\"/>        <Property column=\"marital_status\" name=\"Marital Status\"/>        <Property column=\"education\" name=\"Education\"/>        <Property column=\"yearly_income\" name=\"Yearly Income\"/>      </Level>    </Hierarchy>  </Dimension>  <Dimension foreignKey=\"customer_id\" name=\"Education Level\">    <Hierarchy hasAll=\"true\" primaryKey=\"customer_id\">      <Table name=\"customer\"/>      <Level column=\"education\" name=\"Education Level\" uniqueMembers=\"true\"/>    </Hierarchy>  </Dimension>  <Dimension foreignKey=\"customer_id\" name=\"Gender\">    <Hierarchy allMemberName=\"All Gender\" hasAll=\"true\" primaryKey=\"customer_id\">      <Table name=\"customer\"/>      <Level column=\"gender\" name=\"Gender\" uniqueMembers=\"true\"/>    </Hierarchy>  </Dimension>  <Dimension foreignKey=\"customer_id\" name=\"Marital Status\">    <Hierarchy allMemberName=\"All Marital Status\" hasAll=\"true\" primaryKey=\"customer_id\">      <Table name=\"customer\"/>      <Level column=\"marital_status\" name=\"Marital Status\" uniqueMembers=\"true\"/>    </Hierarchy>  </Dimension>  <Dimension foreignKey=\"customer_id\" name=\"Yearly Income\">    <Hierarchy hasAll=\"true\" primaryKey=\"customer_id\">      <Table name=\"customer\"/>      <Level column=\"yearly_income\" name=\"Yearly Income\" uniqueMembers=\"true\"/>    </Hierarchy>  </Dimension>  <Measure aggregator=\"sum\" column=\"unit_sales\" formatString=\"Standard\" name=\"Unit Sales\"/>  <Measure aggregator=\"sum\" column=\"store_cost\" formatString=\"#,###.00\" name=\"Store Cost\"/>  <Measure aggregator=\"sum\" column=\"store_sales\" formatString=\"#,###.00\" name=\"Store Sales\"/>  <Measure aggregator=\"count\" column=\"product_id\" formatString=\"#,###\" name=\"Sales Count\"/>  <Measure aggregator=\"distinct-count\" column=\"customer_id\" formatString=\"#,###\" name=\"Customer Count\"/></Cube><Cube name=\"Sales 2\">   <Table name=\"sales_fact_1997\"/>   <DimensionUsage foreignKey=\"time_id\" name=\"Time\" source=\"Time\"/>   <DimensionUsage foreignKey=\"product_id\" name=\"Product\" source=\"Product\"/>   <Dimension foreignKey=\"customer_id\" name=\"Gender\">     <Hierarchy allMemberName=\"All Gender\" hasAll=\"true\" primaryKey=\"customer_id\">       <Table name=\"customer\"/>       <Level column=\"gender\" name=\"Gender\" uniqueMembers=\"true\"/>     </Hierarchy>   </Dimension>   <Measure aggregator=\"count\" column=\"product_id\" formatString=\"#,###\" name=\"Sales Count\">     <CalculatedMemberProperty name=\"MEMBER_ORDINAL\" value=\"1\"/>   </Measure>   <Measure aggregator=\"sum\" column=\"unit_sales\" formatString=\"Standard\" name=\"Unit Sales\">     <CalculatedMemberProperty name=\"MEMBER_ORDINAL\" value=\"2\"/>   </Measure>   <Measure aggregator=\"sum\" column=\"store_sales\" formatString=\"#,###.00\" name=\"Store Sales\">      <CalculatedMemberProperty name=\"MEMBER_ORDINAL\" value=\"3\"/>    </Measure>   <Measure aggregator=\"sum\" column=\"store_cost\" formatString=\"#,###.00\" name=\"Store Cost\">      <CalculatedMemberProperty name=\"MEMBER_ORDINAL\" value=\"6\"/>    </Measure>   <Measure aggregator=\"distinct-count\" column=\"customer_id\" formatString=\"#,###\" name=\"Customer Count\">      <CalculatedMemberProperty name=\"MEMBER_ORDINAL\" value=\"7\"/>    </Measure>   <CalculatedMember dimension=\"Measures\" name=\"Profit\">     <Formula>[Measures].[Store Sales] - [Measures].[Store Cost]</Formula>     <CalculatedMemberProperty name=\"FORMAT_STRING\" value=\"$#,##0.00\"/>     <CalculatedMemberProperty name=\"MEMBER_ORDINAL\" value=\"4\"/>   </CalculatedMember>   <CalculatedMember dimension=\"Measures\" formula=\"COALESCEEMPTY((Measures.[Profit], [Time].[Time].PREVMEMBER),    Measures.[Profit])\" name=\"Profit last Period\" visible=\"false\">      <CalculatedMemberProperty name=\"MEMBER_ORDINAL\" value=\"5\"/>   </CalculatedMember></Cube></Catalog></output>" }

  let(:nofound_response) { "<output>No Cubes found.</output>" }

  let(:success_update_reponse) { "<output>Cube modified successfully</output>" }

  let(:success_create_response) { "<output>Cube is successfully added to an existing catalog.</output>" }

  let(:success_create_catalog_response) { "<output>Catalog creation was successful</output>" }

  let(:failure_create_catalog_response) { "<output>Catalog mycat already exists</output>" }

  let(:failure_get_catalog_response) { "<output>No Catalogs found.</output>" }

  let(:success_del_response) { "<output>Cube successfully deleted</output>" }

  let(:success_catalog_del_response) { "<output>Catalog successfully deleted</output>" }

  let(:fail_catalog_del_response) { "<output>Deletion failed</output>" }

  let(:success_invalidatecache_cube_response) { "<output>Cache clearance for Cube mycube is successful</output>" }

  let(:success_invalidatecache_catalog_response) { "<output>Cache clearance for Catalog mycat is successful</output>" }

  it "sets the host and port for a connection" do
    expect(connection.base_url).to eq(RSPEC_TEST_URL)
    expect(connection.url.host).to eq("validurl")
    expect(connection.url.port).to eq(8080)
  end

  describe 'shows cube for given catalog name' do
    it "gets not found message if a cube's definition is not found" do
      stub_request(:get, "http://validurl:8080/").
          with(:headers => {'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host' => 'validurl:8080', 'User-Agent' => 'Ruby'}).
          to_return(:status => 200, :body => nofound_response, :headers => {})
      expect(connection.get_cube('mycat', 'mycube')).not_to be_empty
      expect(connection.list_objs.first.to_s.include? "No Cubes found.").to be true
    end

    it "gets cube if a cube's definition is not found" do
      stub_request(:get, "http://validurl:8080/").
          with(:headers => {'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host' => 'validurl:8080', 'User-Agent' => 'Ruby'}).
          to_return(:status => 200, :body => success_reponse, :headers => {})
      expect(connection.get_cube('mycat', 'mycube')).not_to be_empty
      connection.list_objs.each { |obj|
        if obj.class.to_s.eql?("Mondrian::CubeClient::Catalog")
          expect(obj.name.eql? "mycat").to be true
          expect(obj.list_cubes.count).to eq(1)
          obj.list_cubes.each { |cube|
            expect(cube.name.eql?("mycube")).to be true
          }
        end
      }
    end
  end

  describe 'show cube for given cube name' do
    it "gets a cube's definition" do
      stub_request(:get, "http://validurl:8080/").
          with(:headers => {'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host' => 'validurl:8080', 'User-Agent' => 'Ruby'}).
          to_return(:status => 200, :body => success_reponse, :headers => {})
      expect(connection.get_cube('', 'mycube')).not_to be_empty
      connection.list_objs.each { |obj|
        if obj.class.to_s.eql?("Mondrian::CubeClient::Catalog")
          expect(obj.name.eql? "mycat").to be true
          expect(obj.list_cubes.count).to eq(1)
          obj.list_cubes.each { |cube|
            expect(cube.name.eql?("mycube")).to be true
          }
        end
      }
    end
  end

  describe 'list all cubes' do
    it "gets all cubes with definitions" do
      stub_request(:get, "http://validurl:8080/").
          with(:headers => {'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host' => 'validurl:8080', 'User-Agent' => 'Ruby'}).
          to_return(:status => 200, :body => success_multiple_cubes_reponse, :headers => {})
      expect(connection.list_cubes()).not_to be_empty
      connection.list_objs.each { |obj|
        if obj.class.to_s.eql?("Mondrian::CubeClient::Catalog")
          expect(obj.name.eql? "mycat").to be true
          expect(obj.list_cubes.count).to eq(6)
        end
      }
    end
  end

  describe 'updates a cube' do
    it "updates a cube's definition" do
      stub_request(:put, "http://validurl:8080/mondrian/cubecrudapi/putcube/mycat/mycube").
          with(:body => "<Schema name=\"postgres\">\n  <Dimension name=\"Date dimensions\">\n    <Hierarchy hasAll=\"true\" name=\"Created at\" primaryKey=\"id\">\n      <Table name=\"&quot;date_dimensions&quot;\" schema=\"&quot;public&quot;\"/>\n      <Table name=\"&quot;time_dimensions&quot;\" schema=\"&quot;public&quot;\"/>\n      <Level column=\"minute\" name=\"Minute\" type=\"String\" uniqueMembers=\"false\"></Level>\n    </Hierarchy>\n  </Dimension>\n  <Cube name=\"postgres\">\n    <Measure aggregator=\"max\" column=\"price\" formatString=\"#\" name=\"max_price\"/>\n  </Cube>\n</Schema>",
               :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'text/plain', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => success_update_reponse, :headers => {})

      expect(connection.update_cube('mycat', 'mycube', cubedefinition)).to be true
    end
  end

  describe 'creates cube' do
    it "creates a cube" do
      stub_request(:put, "http://validurl:8080/mondrian/cubecrudapi/putcube/mycat/mycube").
          with(:body => "<Schema name=\"postgres\">\n  <Dimension name=\"Date dimensions\">\n    <Hierarchy hasAll=\"true\" name=\"Created at\" primaryKey=\"id\">\n      <Table name=\"&quot;date_dimensions&quot;\" schema=\"&quot;public&quot;\"/>\n      <Table name=\"&quot;time_dimensions&quot;\" schema=\"&quot;public&quot;\"/>\n      <Level column=\"minute\" name=\"Minute\" type=\"String\" uniqueMembers=\"false\"></Level>\n    </Hierarchy>\n  </Dimension>\n  <Cube name=\"postgres\">\n    <Measure aggregator=\"max\" column=\"price\" formatString=\"#\" name=\"max_price\"/>\n  </Cube>\n</Schema>",
               :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'text/plain', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => success_create_response, :headers => {})

      expect(connection.create_cube('mycat', 'mycube', cubedefinition)).to be true
    end
  end

  describe 'delete cube' do
    it "deletes a cube" do
      stub_request(:delete, "http://validurl:8080/mondrian/cubecrudapi/deletecube/mycat/mycube").
          to_return(:status => 200, :body => success_del_response, :headers => {})
      expect(connection.delete_cube('mycat', 'mycube').include?("successfully delete")).to be true
    end
  end

  describe 'delete catalog' do
    it "returns true on successful deletion of a catalog" do
      stub_request(:delete, "http://validurl:8080/mondrian/cubecrudapi/catalog/mycat").
          to_return(:status => 200, :body => success_catalog_del_response, :headers => {})
      expect(connection.delete_catalog('mycat')).to be true
    end

    it "returns false on deletion failure of a catalog" do
      stub_request(:delete, "http://validurl:8080/mondrian/cubecrudapi/catalog/mycat").
          to_return(:status => 200, :body => fail_catalog_del_response, :headers => {})
      expect(connection.delete_catalog('mycat')).to be false
    end
  end

  describe 'invalidate cache for a cube' do
    it "invalidates cache for a cube" do
      stub_request(:put, "http://validurl:8080/mondrian/cubecrudapi/invalidatecache/cube/mycube").
          with(:headers => {'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type' => 'text/plain', 'User-Agent' => 'Ruby'}).
          to_return(:status => 200, :body => success_invalidatecache_cube_response, :headers => {})

      expect(connection.invalidate_cache_cube('mycube').include?("Cache clearance")).to be true
    end
  end

  describe 'invalidate cache for a catalog' do
    it "invalidates cache for a catalog" do
      stub_request(:put, "http://validurl:8080/mondrian/cubecrudapi/invalidatecache/catalog/mycat").
          with(:body => "", :headers => {'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type' => 'text/plain', 'User-Agent' => 'Ruby'}).
          to_return(:status => 200, :body => success_invalidatecache_cube_response, :headers => {})
      expect(connection.invalidate_cache_catalog('mycat').include?("Cache clearance")).to be true
    end
  end

  describe 'creates catalog' do
    it "creates a catalog" do
      stub_request(:put, "http://validurl:8080/mondrian/cubecrudapi/catalog/mycat").
          with(:body => "<CatalogDefinition>\n  <DataSource>\n    JdbcDrivers=org.postgresql.Driver;Provider=Mondrian;Jdbc=jdbc:postgresql://localhost:3306/database_name?user=username&#38;password=password;\n  </DataSource>\n</CatalogDefinition>",
               :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'text/plain', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => success_create_catalog_response, :headers => {})

      connect_string = "localhost:3306/database_name?user=username&#38;password=password;"
      expect(connection.create_catalog('mycat', connect_string)).to be true
    end

    it "does not create a catalog if a catalog already exists" do
      stub_request(:put, "http://validurl:8080/mondrian/cubecrudapi/catalog/mycat").
          with(:body => "<CatalogDefinition>\n  <DataSource>\n    JdbcDrivers=org.postgresql.Driver;Provider=Mondrian;Jdbc=jdbc:postgresql://localhost:3306/database_name?user=username&#38;password=password;\n  </DataSource>\n</CatalogDefinition>",
               :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'text/plain', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => failure_create_catalog_response, :headers => {})

      connect_string = "localhost:3306/database_name?user=username&#38;password=password;"
      expect(connection.create_catalog('mycat', connect_string)).to be false
    end
  end

  describe "show a catalog if present" do
    it "gets a catalog definition when catalog is present" do
      stub_request(:get, "http://validurl:8080/").
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'validurl:8080', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => success_multiple_cubes_reponse, :headers => {})
      expect(connection.get_catalog('mycat')).not_to be_empty
      expect(connection.list_objs[0].class).to eq(Mondrian::CubeClient::Catalog)
      expect(connection.list_objs[0].name.eql?"mycat").to be true
    end

    it "gets error message when catalog is not found " do
      stub_request(:get, "http://validurl:8080/").
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'validurl:8080', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => failure_get_catalog_response, :headers => {})
      expect(connection.get_catalog('mycat')).not_to be_empty
      expect(connection.list_objs[0].eql?("<output>No Catalogs found.</output>")).to be true
    end

  end
end
