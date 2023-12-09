%{
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>
    int yyerror();
    int yylex();
    
    struct macro 
    {
      char* name;
      char* args;
      char* body;
      int type_of_macro;
    };

    struct macro macro_arr[10000];
    int indexi = 0;
    
    char* replaceMacros(char* fun_name, char* fun_args , int which_type)
    {
     
       int  present =0;
       
      for(int i=0;i<indexi;i++)
      {

        if (!strcmp(macro_arr[i].name,fun_name))
        {
           
           present=1;
           int n = strlen(fun_args);
           int j=0;
           int count =0;
         
           char *token;
          if(which_type!=macro_arr[i].type_of_macro)
          {
            yyerror();
          }
        
          if(n!=0)  
         { 
          int first_index =0;
          char* fun_args_temp = strdup(fun_args);
          token = strtok(fun_args_temp, ",");
          
          while (token != NULL)
          {            
              token = strtok(NULL, ","); 
              first_index++;
          }
          

          char** split_words = (char**)malloc(first_index*sizeof(char));

          token = strtok(fun_args, ",");
         
          split_words[0] = (char*)malloc(strlen(token)+10);

          strcpy(split_words[0],token);
          
           int h =1;
          while (h < first_index)
          {
              
             token = strtok(NULL, ","); 
              split_words[h] = (char*)malloc(strlen(token));
              split_words[h] = token;
              h++;
              
          }
          
          int second_index =0;
         
          
          char* my_args_temp = (char*)malloc(strlen(macro_arr[i].args)+10);
          strcpy(my_args_temp, macro_arr[i].args);
          
          token = strtok(my_args_temp, ",");
          
          while (token != NULL)
          {
              
              token = strtok(NULL, ","); 
              second_index++;
          }
         
          
          char** split_words_args = (char**)malloc(second_index*sizeof(char));
          char* my_args = (char*)malloc(strlen(macro_arr[i].args)+10);
          strcpy(my_args,macro_arr[i].args);
         
          token = strtok(my_args, ",");
          split_words_args[0] = strdup(token);
          
           int b =1;
          while (b < second_index)
          {
              
             token = strtok(NULL, ",");
              split_words_args[b]=strdup(token);
              b++;
              
          }
          
          for(int f =0;f<second_index;f++)
           {
              char* temp2;
              temp2 = strtok(split_words_args[f]," ");
              split_words_args[f] = (char*)malloc(strlen(temp2));
              strcpy(split_words_args[f],temp2);
           }
           
           if(first_index!=second_index)
           {
             yyerror();
           }
          char* temp_body = (char*)malloc(strlen(macro_arr[i].body)+88);
          strcpy(temp_body,macro_arr[i].body);
          
          int third_index =0;
          
          char* changed_stmt  = (char*)malloc(5);
          strcpy(changed_stmt,"");
          token = strtok(temp_body, " ");
          char* wait = strdup(token);
         
          int found=0;
          for(int v=0;v<second_index;v++)
          {
            
            if(!strcmp(wait,split_words_args[v]))
            {
              
                changed_stmt = (char*)realloc(changed_stmt,(strlen(changed_stmt)+ 9+ strlen(split_words[v])));
                
                strcat(changed_stmt,split_words[v]);
                
                strcat(changed_stmt," ");
                found=1;
              
            }
          }
          if(found==0)
           {
            changed_stmt = (char*)realloc(changed_stmt,(strlen(changed_stmt)+6+ strlen(wait)));
            strcat(changed_stmt,wait);
            strcat(changed_stmt," ");
           }
         
          while (token != NULL)
          {   
              int myfound=0;   
              token = strtok(NULL, " "); 
              
              if(token!=NULL)
              {
                char* okay = strdup(token);
              for(int v=0;v<second_index;v++)
              {
                if(!strcmp(okay,split_words_args[v]))
                {
                  
                      changed_stmt = (char*)realloc(changed_stmt,(strlen(changed_stmt)+ 9+ strlen(split_words[v])));
                     
                      strcat(changed_stmt,split_words[v]);
                     
                      strcat(changed_stmt," ");
                      myfound=1;
                    
                }
              }

                if(myfound==0)
                {
                  changed_stmt = (char*)realloc(changed_stmt,(strlen(changed_stmt)+ 7+ strlen(okay)));
                  strcat(changed_stmt,okay);
                  strcat(changed_stmt," ");
                }
              }

               third_index++;
          }
          
          return strdup(changed_stmt);
          
         }
         else
         {
          return strdup(macro_arr[i].body);
         }
           break;
          }
        
      }
      if(present ==0)
      {
        yyerror();
       
      }
    
        
    }

    

%}

%union{
    char* ch;
    int num;
}

%token<ch> NUMBER
%token<ch> ADD SUB MUL DIV ABS MAX
%token<ch> LB RB LCB RCB LSB RSB SEMICOLON
%token<ch> EOL
%token<ch> EQUAL
%token<ch> NEQL 
%token<ch> IF ELSE THIS DO WHILE RET EXTENDS CLASS NEW PUBLIC STATIC VOID MAIN LEN SYSOUT INT INT_ARRAY BOOL
%token<ch> TRU FALS
%token<ch> DEF
%token<ch> STRING ID DOT NOT OR LTE AND COMMA

%type<ch> goal macro_definitions main_class type_declarations type_declaration tis method_declarations method_declaration 
%type<ch> optional_tis other_tis type statements statement optional_args other_optional_args expression primary_expression
%type<ch> macro_def_statement macro_def_exp optional_inp_args other_optional_inp_args identifier integer

%%

goal: macro_definitions main_class type_declarations { printf("%s\n %s\n",$2,$3);
                                                      } 

macro_definitions: {$$ = strdup("");}
                  |  macro_definitions  macro_def_exp { $$ = (char*)malloc((strlen($1)+strlen($2)+20)*sizeof(char));
                                                        strcpy($$, $1); strcat($$, " ");
                                                        strcat($$, $2);  }
                  |  macro_definitions  macro_def_statement {
                                                        $$ = (char*)malloc((strlen($1)+strlen($2)+20)*sizeof(char));
                                                        strcpy($$, $1); strcat($$, " ");
                                                        strcat($$, $2); 

                                                             }
                  ;
main_class: CLASS identifier LCB PUBLIC STATIC VOID MAIN LB STRING LSB RSB identifier RB LCB SYSOUT
 LB expression RB SEMICOLON RCB RCB { int length = strlen($1) + strlen($2) + strlen($3)+strlen($4)+strlen($5) + strlen($6) + strlen($7)+strlen($8)+strlen($9) + strlen($10) + strlen($11)+strlen($12)+strlen($13) + strlen($14) + strlen($15)+strlen($16)+strlen($17) + strlen($18) + strlen($19)+strlen($20)+strlen($21);
  
  $$ = (char*)malloc((length+200)*sizeof(char));strcpy($$,"class");strcat($$," ");strcat($$,$2);strcat($$,"{");strcat($$,"\n");strcat($$,"\t");strcat($$,"public");strcat($$," ");strcat($$,"static");strcat($$," ");strcat($$,"void");strcat($$," ");strcat($$,"main");strcat($$,"(");strcat($$,"String");strcat($$,"[");strcat($$,"]");strcat($$," ");strcat($$,$12);strcat($$,")");strcat($$,"{");strcat($$,"\n");strcat($$,"\t");strcat($$,"System.out.println");strcat($$,"(");strcat($$,$17);strcat($$,")");strcat($$,";");strcat($$,"\n");strcat($$,"\t");strcat($$,"}");strcat($$,"\n");strcat($$,"}\n"); };


 

type_declarations : {$$ = strdup("");}
                  | type_declarations type_declaration {
                                                          $$ = (char*)malloc((strlen($1)+strlen($2)+50)*sizeof(char));
                                                          $$ = strcpy($$, $1); $$ = strcat($$, " ");
                                                          $$ = strcat($$, $2); $$ = strcat($$, " ");
                                                          

                                                       }
                  ;
type_declaration : CLASS identifier LCB tis method_declarations RCB {   $$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+strlen($6)+50)*sizeof(char));
                                                                $$ = strcpy($$, $1); $$ = strcat($$, " ");
                                                                $$ = strcat($$, $2); $$ = strcat($$, " ");
                                                                $$ = strcat($$, $3); $$ = strcat($$, " \n ");
                                                                $$ = strcat($$, $4); $$ = strcat($$, " ");
                                                                $$ = strcat($$, $5); $$ = strcat($$, " ");
                                                                $$ = strcat($$, $6); $$ = strcat($$, " "); $$ = strcat($$,"\n");$$ = strcat($$, " ");}
                 | CLASS identifier EXTENDS identifier LCB tis method_declarations RCB {   $$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+strlen($6)+strlen($7)+70)*sizeof(char));
                                                                $$ = strcpy($$, $1); $$ = strcat($$, " ");
                                                                $$ = strcat($$, $2); $$ = strcat($$, " ");
                                                                $$ = strcat($$, $3); $$ = strcat($$, " ");
                                                                $$ = strcat($$, $4); $$ = strcat($$, " ");
                                                                $$ = strcat($$, $5); $$ = strcat($$, " \n ");
                                                                $$ = strcat($$, $6); $$ = strcat($$, " ");
                                                                $$ = strcat($$, $7); $$ = strcat($$, " "); $$= strcat($$,$8);$$ = strcat($$," "); $$ = strcat($$,"\n"); $$ = strcat($$, " ");}
                 ;

tis : {$$ = strdup("");}
    |  tis type identifier SEMICOLON {
                                       $$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+40)*sizeof(char));
                                                                $$ = strcpy($$, $1); $$ = strcat($$, " ");
                                                                $$ = strcat($$, $2); $$ = strcat($$, " ");
                                                                $$ = strcat($$, $3); $$ = strcat($$, " ");
                                                                $$ = strcat($$, $4); $$ = strcat($$, " ");
                                                                $$ = strcat($$, "\n"); $$ = strcat($$, " ");
                                                                
                                     }
    ;

method_declarations : {$$ = strdup("");}
                    |  method_declarations  method_declaration {$$ = (char*)malloc((strlen($1)+strlen($2)+20)*sizeof(char));
                                                                $$ = strcpy($$, $1); $$ = strcat($$, " ");
                                                                $$ = strcat($$, $2); $$ = strcat($$, " ");}
                    ;

method_declaration : PUBLIC type identifier LB optional_tis RB LCB tis statements RET expression SEMICOLON RCB {
                                                      $$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+strlen($6)+strlen($7)+strlen($8)+strlen($9)+strlen($10)+strlen($11)+strlen($12)+strlen($13)+90)*sizeof(char));
                                                      $$ = strcpy($$, $1); $$ = strcat($$, " ");
                                                      $$ = strcat($$, $2); $$ = strcat($$, " ");
                                                       $$ = strcat($$, $3); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $4); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $5); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $6); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $7); $$ = strcat($$, " \n ");
                                                        $$ = strcat($$, $8); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $9); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $10); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $11); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $12); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $13); $$= strcat($$," ");$$ = strcat($$,"\n"); $$ = strcat($$, " ");}
                   ;
optional_tis : {$$ = strdup("");}
             | type identifier other_tis { $$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+25)*sizeof(char));
                                                      $$ = strcpy($$, $1); $$ = strcat($$, " ");
                                                      $$ = strcat($$, $2); $$ = strcat($$, " ");
                                                      $$ = strcat($$, $3); $$ = strcat($$, " ");}      
             ;
other_tis : {$$ = strdup("");}
          | other_tis COMMA type identifier {
            $$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+40)*sizeof(char));
                                                      $$ = strcpy($$, $1); $$ = strcat($$, " ");
                                                      $$ = strcat($$, $2); $$ = strcat($$, " ");
                                                      $$ = strcat($$, $3); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $4); $$ = strcat($$, " ");
             
          }
          ;

type : INT LSB RSB {
              $$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+30)*sizeof(char));
                                                      $$ = strcpy($$, $1); $$ = strcat($$, " ");
                                                      $$ = strcat($$, $2); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $3); $$ =strcat($$, " ");}
     | BOOL {  $$ = (char*)malloc((strlen($1)+20)*sizeof(char));
                                    $$ = strcpy($$, $1); strcat($$," ");}
     | INT  {  $$ = (char*)malloc((strlen($1)+20)*sizeof(char));
                                    $$ = strcpy($$, $1); strcat($$, " ");}
     | identifier {  $$ = (char*)malloc((strlen($1)+20)*sizeof(char));
                                    $$ = strcpy($$, $1);strcat($$, " ");}
     ;

statements : {$$ = strdup("");} 
           | statement statements {
              $$ = (char*)malloc((strlen($1)+strlen($2)+20)*sizeof(char));
                                                      $$ = strcpy($$, $1); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $2); strcat($$, " ");
                                                        
           }
           ;

statement : LCB statements RCB { 
                                 $$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+30)*sizeof(char));
                                                      $$ = strcpy($$, $1); $$ = strcat($$, " \n ");
                                                        $$ = strcat($$, $2); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $3); $$ = strcat($$, " ");$$ = strcat($$,"\n"); $$ = strcat($$, " ");


                                }
          | SYSOUT LB expression RB SEMICOLON {
                                                      $$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+50)*sizeof(char));
                                                      $$ = strcpy($$, $1); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $2); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $3); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $4); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $5); $$ = strcat($$, " ");$$ = strcat($$,"\n"); $$ = strcat($$, " ");
                                                        
                
                                                      }
          | identifier EQUAL expression SEMICOLON  {
                                                      $$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+40)*sizeof(char));
                                                      $$ = strcpy($$, $1); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $2); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $3); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $4); $$ = strcat($$, " ");$$ = strcat($$,"\n");  $$ = strcat($$, " ");
                
                                                      }
          | identifier LSB expression RSB EQUAL expression SEMICOLON {
                                                      $$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+strlen($6)+strlen($7)+70)*sizeof(char));
                                                      $$ = strcpy($$, $1); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $2); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $3); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $4); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $5); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $6); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $7); $$ = strcat($$, " ");$$ = strcat($$,"\n"); $$ = strcat($$, " ");
                
                                                      }
          | IF LB expression RB statement {
                                                $$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+70)*sizeof(char));
                                                      $$ = strcpy($$, $1); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $2); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $3); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $4); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $5); $$ = strcat($$, " "); $$ = strcat($$,"\n");$$ = strcat($$," ");
                                           }
          | IF LB expression RB statement ELSE statement  {
                                                      $$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+strlen($6)+strlen($7)+70)*sizeof(char));
                                                      $$ = strcpy($$, $1); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $2); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $3); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $4); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $5); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $6); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $7); $$ = strcat($$, " "); $$ = strcat($$,"\n"); $$ = strcat($$, " ");
                                                        
                
                                                      }
          | DO statement WHILE LB expression RB SEMICOLON {
                                                      $$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+strlen($6)+strlen($7)+70)*sizeof(char));
                                                      $$ = strcpy($$, $1); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $2); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $3); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $4); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $5); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $6); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $7); $$ = strcat($$, " "); $$ = strcat($$,"\n"); $$ = strcat($$, " ");
                
                                                      }
          | WHILE LB expression RB statement  {
                                                      $$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+50)*sizeof(char));
                                                      $$ = strcpy($$, $1); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $2); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $3); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $4); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $5); $$ = strcat($$, " "); $$ = strcat($$,"\n"); $$ = strcat($$, " ");
                
                                                      }
          | identifier LB optional_args RB SEMICOLON {
                                                      $$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+50)*sizeof(char));
                                                      $$ = strcpy($$, $1); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $2); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $3); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $4); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $5); $$ = strcat($$, " ");$$ = strcat($$,"\n"); $$ = strcat($$, " ");
                                                        char* temp;
                                                        temp = strdup(replaceMacros($1,$3,1));
                                                        
                                                        $$ = (char*)malloc(strlen(temp)+10);
                                                        strcpy($$,temp);
                                                        strcat($$," ");
                                                        strcat($$,"\n"); $$ = strcat($$, " ");
                
                                                      }
          ;

optional_args : {$$ = strdup("");}
              | expression other_optional_args {
                                                $$ = (char*)malloc((strlen($1)+strlen($2)+20)*sizeof(char));
                                                $$ = strcpy($$, $1); $$ =strcat($$, " ");
                                                $$ = strcat($$, $2); $$ = strcat($$, " ");
                                               }

other_optional_args : {$$ = strdup("");}
                    | other_optional_args COMMA expression {
                                                              $$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+30)*sizeof(char));
                                                              $$ = strcpy($$, $1); $$ =strcat($$, " ");
                                                              $$ = strcat($$, $2); $$ = strcat($$, " ");
                                                              $$ = strcat($$, $3); $$ = strcat($$, " ");
                                                           }


expression : primary_expression AND primary_expression { 
                                                        $$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+30)*sizeof(char));
                                                        $$ = strcpy($$, $1); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $2); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $3); $$ = strcat($$, " ");
                                                       }

           | primary_expression OR primary_expression { 
                                                        $$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+30)*sizeof(char));
                                                        $$ = strcpy($$, $1); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $2); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $3); $$ = strcat($$, " ");
                                                      }

           | primary_expression NEQL primary_expression{ 
                                                        $$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+30)*sizeof(char));
                                                        $$ = strcpy($$, $1); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $2); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $3); $$ = strcat($$, " ");
                                                        }
           | primary_expression LTE primary_expression { 
                                                        $$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+30)*sizeof(char));
                                                        $$ = strcpy($$, $1); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $2); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $3); $$ = strcat($$, " ");
                                                        }
           | primary_expression ADD primary_expression { 
                                                        $$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+30)*sizeof(char));
                                                        $$ = strcpy($$, $1); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $2); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $3); $$ = strcat($$, " ");
                                                       }
           | primary_expression SUB primary_expression { 
                                                        $$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+30)*sizeof(char));
                                                        $$ = strcpy($$, $1); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $2); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $3); $$ = strcat($$, " ");
                                                       }
           | primary_expression MUL primary_expression { 
                                                        $$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+30)*sizeof(char));
                                                        $$ = strcpy($$, $1); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $2); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $3); $$ = strcat($$, " ");
                                                       }
           | primary_expression DIV primary_expression { 
                                                        $$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+30)*sizeof(char));
                                                        $$ = strcpy($$, $1); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $2); $$ = strcat($$, " ");
                                                        $$ = strcat($$, $3); $$ = strcat($$, " ");
                                                       }
           | primary_expression LSB primary_expression RSB { 
                                                            $$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+40)*sizeof(char));
                                                            $$ = strcpy($$, $1); $$ = strcat($$, " ");
                                                            $$ = strcat($$, $2); $$ = strcat($$, " ");
                                                            $$ = strcat($$, $3); $$ = strcat($$, " ");
                                                            $$ = strcat($$, $4); $$ = strcat($$, " ");
                                                           }
           | primary_expression DOT  LEN    { 
                                            $$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+30)*sizeof(char));
                                            $$ = strcpy($$, $1); $$ = strcat($$, " ");
                                            $$ = strcat($$, $2); $$ = strcat($$, " ");
                                            $$ = strcat($$, $3); $$ = strcat($$, " ");
                                            }
           | primary_expression { 
                                    $$ = (char*)malloc((strlen($1)+10)*sizeof(char));
                                    $$ = strcpy($$, $1); $$ = strcat($$, " ");
                                }
           | primary_expression DOT identifier LB optional_args RB  { 
                                            $$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+strlen($6)+60)*sizeof(char));
                                            $$ = strcpy($$, $1); $$ = strcat($$, " ");
                                            $$ = strcat($$, $2); $$ = strcat($$, " ");
                                            $$ = strcat($$, $3); $$ = strcat($$, " ");
                                            $$ = strcat($$, $4); $$ = strcat($$, " ");
                                            $$ = strcat($$, $5); $$ = strcat($$, " ");
                                            $$ = strcat($$, $6); $$ = strcat($$, " ");
                                            }
           | identifier LB optional_args RB {  
                                            $$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+40)*sizeof(char));
                                            $$ = strcpy($$, $1); $$ = strcat($$, " ");
                                            $$ = strcat($$, $2); $$ = strcat($$, " ");
                                            $$ = strcat($$, $3); $$ = strcat($$, " ");
                                            $$ = strcat($$, $4); $$ = strcat($$, " ");
                                            char* temp;
                                            temp = strdup(replaceMacros($1,$3,2));
                                            
                                            $$ = (char*)malloc(strlen(temp)+10);
                                            strcpy($$,temp);
                                            strcat($$," ");
                                            
                                            }
           ;
           
    
primary_expression : integer { $$ = (char*)malloc((strlen($1)+10)*sizeof(char));
                                strcpy($$,$1);}
                   | TRU  { $$ = (char*)malloc((strlen($1)+10)*sizeof(char));
                                  strcpy($$,$1);}
                   | FALS { $$ = (char*)malloc((strlen($1)+10)*sizeof(char));
                                  strcpy($$,$1);}
                   | identifier { $$ = (char*)malloc((strlen($1)+10)*sizeof(char));
                                  strcpy($$,$1);}
                   | THIS  { $$ = (char*)malloc((strlen($1)+10)*sizeof(char));
                                  strcpy($$,$1);}
                   | NEW INT LSB expression RSB { $$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+50)*sizeof(char));
                                                  $$ = strcpy($$, $1); $$ = strcat($$, " ");
                                                  $$ = strcat($$, $2); $$ = strcat($$, " ");
                                                  $$ = strcat($$, $3); $$ = strcat($$, " ");
                                                  $$ = strcat($$, $4); $$ = strcat($$, " ");
                                                  $$ = strcat($$, $5); }
                   | NEW identifier LB RB   { $$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+40)*sizeof(char));
                                                  $$ = strcpy($$, $1); $$ = strcat($$, " ");
                                                  $$ = strcat($$, $2); $$ = strcat($$, " ");
                                                  $$ = strcat($$, $3);
                                                  $$ = strcat($$, $4); 
                                                  }
                   | NOT expression  { $$ = (char*)malloc((strlen($1)+strlen($2)+20)*sizeof(char));
                                                  $$ = strcpy($$, $1); $$ = strcat($$, " ");
                                                  $$ = strcat($$, $2); 
                                                  }
                   | LB expression RB { $$ = (char*)malloc((strlen($1)+strlen($2)+20)*sizeof(char));
                                                  $$ = strcpy($$, $1); $$ = strcat($$, " ");
                                                  $$ = strcat($$, $2); $$ = strcat($$, " ");
                                                  $$ = strcat($$, $3); 
                                                  }
                                         
                   ;
    
macro_def_statement : DEF identifier LB optional_inp_args RB LCB statements RCB { 
                                                                                 $$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+strlen($6)+strlen($7)+strlen($8)+80)*sizeof(char));
                                                                                 $$ = strcpy($$, $1); $$ = strcat($$, " ");
                                                                                 $$ = strcat($$, $2); $$ = strcat($$, " ");
                                                                                 $$ = strcat($$, $3); $$ = strcat($$, " ");
                                                                                 $$ = strcat($$, $4); $$ = strcat($$, " ");
                                                                                 $$ = strcat($$, $5); $$ = strcat($$, " ");
                                                                                 $$ = strcat($$, $6); $$ = strcat($$, " \n  ");
                                                                                 $$ = strcat($$, $7); $$ = strcat($$, " ");
                                                                                 $$ = strcat($$, $8); $$ = strcat($$, " \n");
                                                                                 $$ = strcat($$," ");
                                                                                 
                                                                                 for(int j=0; j<indexi;j++)
                                                                                  {
                                                                                    if(!strcmp(macro_arr[j].name,$2))
                                                                                    {
                                                                                      yyerror();
                                                                                    }
                                                                                  }

                                                                                 macro_arr[indexi].name = (char*)malloc(strlen($2)+10);
                                                                                 strcpy(macro_arr[indexi].name, $2);
                                                                                 macro_arr[indexi].args = (char*)malloc(strlen($4)+10);
                                                                                 strcpy(macro_arr[indexi].args, $4);
                                                                                 macro_arr[indexi].body = (char*)malloc(strlen($7)+10);
                                                                                 strcpy(macro_arr[indexi].body, $7);
                                                                                 macro_arr[indexi].type_of_macro = 1;

                                        
                                                                                 indexi++;        
                                                                                 }
                    ;
macro_def_exp : DEF identifier LB optional_inp_args RB LB expression RB { 
                                                                                 $$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+strlen($6)+strlen($7)+strlen($8)+80)*sizeof(char));
                                                                                 
                                                                                 $$ = strcpy($$, $1); $$ = strcat($$, " ");
                                                                                
                                                                                 $$ = strcat($$, $2); $$ = strcat($$, " ");
                                                                                
                                                                                 $$ = strcat($$, $3); $$ = strcat($$, " ");
                                                                                
                                                                                 $$ = strcat($$, $4); $$ = strcat($$, " ");
                                                                                
                                                                                 $$ = strcat($$, $5); $$ = strcat($$, " ");
                                                                                
                                                                                 $$ = strcat($$, $6); $$ = strcat($$, " ");
                                                                                
                                                                                 $$ = strcat($$, $7); $$ = strcat($$, " ");
                                                                                
                                                                                 $$ = strcat($$, $8);  $$ = strcat($$, " ");
                                                                                
                                                                                for(int j=0; j<indexi;j++)
                                                                                {
                                                                                  
                                                                                  if(!strcmp(macro_arr[j].name,$2))
                                                                                  {
                                                                                    yyerror();
                                                                                  }
                                                                                }
                                                                                  
                                                                                 macro_arr[indexi].name = (char*)malloc(strlen($2)+10);
                                                                                 strcpy(macro_arr[indexi].name, $2);
                                                                                 macro_arr[indexi].args = (char*)malloc(strlen($4)+10);
                                                                                 strcpy(macro_arr[indexi].args, $4);
                                                                                 macro_arr[indexi].body = (char*)malloc(strlen($7)+10);
                                                                                 strcpy(macro_arr[indexi].body, $7);
                                                                                 macro_arr[indexi].type_of_macro = 2;
                                                                                 indexi++;
                                                                                
                                                                                 }
              ;
optional_inp_args : { $$ = strdup("");}
                  | identifier other_optional_inp_args { $$ = (char*)malloc((strlen($1) + strlen($2) + 20)*(sizeof(char)));
                                                         $$  = strcpy($$,$1);
                                                         $$ = strcat($$," ");
                                                         $$ = strcat ($$,$2);}
                  ;
other_optional_inp_args : {$$ = strdup("");}
                        | other_optional_inp_args COMMA identifier {
                                                                     $$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+30)*(sizeof(char)));
                                                                     $$ = strcpy($$, $1);
                                                                     $$ = strcat($$," ");
                                                                     $$ = strcat($$,$2);
                                                                     $$ = strcat($$," ");
                                                                     $$ = strcat($$,$3);
                                                                    }
                        ;

identifier : ID   { $$ = (char*)malloc((strlen($1)+2)*sizeof(char));
                  strcpy($$,$1); $$ = strcat($$, " ");
                  
                  
                   }
           ;
integer : NUMBER {$$ = (char*)malloc((strlen($1)+33)*sizeof(char));
                  strcpy($$,$1); $$ = strcat($$, " "); }
        | ADD NUMBER  
        | SUB NUMBER 
        ;




%%    

int main(int argc, char **argv)
{
    yyparse();
}

int yyerror()
{
    printf("// Failed to parse macrojava code.\n"); exit(0);
}

