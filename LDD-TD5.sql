DROP TABLE Etudiant CASCADE CONSTRAINTS;
DROP TABLE Iut CASCADE CONSTRAINTS;
DROP TABLE Postuler CASCADE CONSTRAINTS;

/*Partie 1*/
/*1*/
CREATE TABLE Etudiant
   (
    NumEtu NUMBER NOT NULL,
    PrenomEtu VARCHAR2(50) NOT NULL,
    NomEtu VARCHAR2(50) NOT NULL,
    Moy NUMBER,
    DateNaissance VARCHAR2(50),
    TailleLycee NUMBER,
    CONSTRAINT Pk_Etudiant PRIMARY KEY (NumEtu)  
   ) ;
   
CREATE TABLE Iut
   (
    NomIut VARCHAR2(50) NOT NULL,
    Region VARCHAR2(50) NOT NULL,
    FraisInscription NUMBER,
    CONSTRAINT Pk_Iut PRIMARY KEY (NomIut)  
   ) ;
   
CREATE TABLE Postuler
   (
    NumEtu NUMBER NOT NULL,
    NomIut VARCHAR2(50) NOT NULL,
    Dept VARCHAR2(50),
    Decision VARCHAR2(50),
    CONSTRAINT Pk_Postuler PRIMARY KEY (NumEtu, NomIut, Dept),
    CONSTRAINT Fk_Postuler_Etudiant FOREIGN KEY (NumEtu)  REFERENCES Etudiant(NumEtu),
    CONSTRAINT Pk_Postuler_Iut FOREIGN KEY (NomIut)  REFERENCES Iut(NomIut)    
   ) ;


/*2
="INSERT INTO Etudiant VALUES ("&A2&", '"&B2&"', '"&C2&"', "&D2&", '"&E2&"', "&F2&");"

="INSERT INTO Iut VALUES ('"&A2&"', '"&B2&"', "&C2&");"

="INSERT INTO Postuler VALUES ("&A2&", '"&B2&"', '"&C2&"', '"&D2&"');"
*/

INSERT INTO Etudiant VALUES (123, 'Bob', 'Plat', 10, '10/10/2000', 1000);
INSERT INTO Etudiant VALUES (234, 'Peter', 'Pan', 2, '10/11/2000', 500);
INSERT INTO Etudiant VALUES (345, 'Louise', 'Michele', 20, '29/05/1830', 100);
INSERT INTO Etudiant VALUES (456, 'Arvo', 'Part', 20, '11/09/1935', 1000);
INSERT INTO Etudiant VALUES (567, 'Lisa', 'Rasu', 15, '09/12/1969', 200);
INSERT INTO Etudiant VALUES (678, 'Lison', 'Iva', 11, '01/01/2000', 150);
INSERT INTO Etudiant VALUES (789, 'Gertrude', 'Dure', 12, '02/04/2000', 1000);
INSERT INTO Etudiant VALUES (890, 'Olive', 'Etome', 10, '05/07/2000', 1000);
INSERT INTO Etudiant VALUES (901, 'Lison', 'Iva', 11, '01/01/2000', 150);

INSERT INTO Iut VALUES ('IUT Dijon', 'Bourgogne', 500);
INSERT INTO Iut VALUES ('IUT Le Creusot', 'Bourgogne', 250);
INSERT INTO Iut VALUES ('IUT Marseille', 'PACA', 1000);
INSERT INTO Iut VALUES ('IUT Pau', 'Aquitaine', 2000);
INSERT INTO Iut VALUES ('IUT Paris', 'IdF', 5000);
INSERT INTO Iut VALUES ('IUT Toulouse', 'Languedoc', 1000);

INSERT INTO Postuler VALUES (123, 'IUT Dijon', 'IQ', 'OK');
INSERT INTO Postuler VALUES (123, 'IUT Dijon', 'GMP', 'OK');
INSERT INTO Postuler VALUES (234, 'IUT Marseille', 'IQ', 'OK');
INSERT INTO Postuler VALUES (234, 'IUT Le Creusot', 'GMP', 'KO');
INSERT INTO Postuler VALUES (345, 'IUT Dijon', 'GB', 'KO');
INSERT INTO Postuler VALUES (345, 'IUT Marseille', 'MMI', 'OK');
INSERT INTO Postuler VALUES (456, 'IUT Pau', 'IQ', 'OK');
INSERT INTO Postuler VALUES (456, 'IUT Toulouse', 'IQ', 'OK');
INSERT INTO Postuler VALUES (567, 'IUT Dijon', 'MMI', 'OK');
INSERT INTO Postuler VALUES (567, 'IUT Le Creusot', 'IQ', 'KO');
INSERT INTO Postuler VALUES (678, 'IUT Dijon', 'MMI', 'KO');
INSERT INTO Postuler VALUES (789, 'IUT Dijon', 'IQ', 'OK');
INSERT INTO Postuler VALUES (890, 'IUT Le Creusot', 'IQ', 'OK');
INSERT INTO Postuler VALUES (901, 'IUT Dijon', 'GB', 'KO');
INSERT INTO Postuler VALUES (901, 'IUT Marseille', 'IQ', 'KO');
INSERT INTO Postuler VALUES (901, 'IUT Dijon', 'MMI', 'OK');
INSERT INTO Postuler VALUES (901, 'IUT Dijon', 'GMP', 'OK');


/*Partie 2*/
/*1*/
CREATE OR REPLACE FUNCTION ageEtudiant
  (p_NumEtu Etudiant.NumEtu%TYPE) RETURN NUMBER
IS
  l_ageEtu NUMBER;
  l_dateNaissance DATE;
BEGIN
  SELECT Etudiant.DateNaissance
  INTO l_dateNaissance
  FROM Etudiant
  WHERE Etudiant.NumEtu = p_NumEtu;
  l_ageEtu := EXTRACT(YEAR FROM TO_DATE(TO_CHAR(SYSDATE, 'YYYY/MM/DD'), 'YYYY/MM/DD')) - EXTRACT(YEAR FROM TO_DATE(TO_CHAR(l_dateNaissance, 'YYYY/MM/DD'), 'YYYY/MM/DD'));
  RETURN l_ageEtu;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('L''etudiant ' || p_NumEtu || ' n''existe pas.');
    RETURN -1;
END;
/

CREATE OR REPLACE PROCEDURE ageEtudiantProc
  (p_NumEtu IN Etudiant.NumEtu%TYPE, p_ageEtu OUT NUMBER)
IS
  l_dateNaissance DATE;
BEGIN
  SELECT Etudiant.DateNaissance
  INTO l_dateNaissance
  FROM Etudiant
  WHERE Etudiant.NumEtu = p_NumEtu;
  p_ageEtu := EXTRACT(YEAR FROM TO_DATE(TO_CHAR(SYSDATE, 'YYYY/MM/DD'), 'YYYY/MM/DD')) - EXTRACT(YEAR FROM TO_DATE(TO_CHAR(l_dateNaissance, 'YYYY/MM/DD'), 'YYYY/MM/DD'));
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('L''etudiant ' || p_NumEtu || ' n''existe pas.');
  WHEN VALUE_ERROR THEN
    DBMS_OUTPUT.PUT_LINE('Erreur de valeur.');
END;
/

SET SERVEROUTPUT ON
BEGIN
  DBMS_OUTPUT.PUT_LINE(ageEtudiant(1));
END;
/

SET SERVEROUTPUT ON
DECLARE
  l_numEtu NUMBER := 123;
  l_ageEtu NUMBER;
BEGIN
  ageEtudiantProc(l_numEtu, l_ageEtu);
  DBMS_OUTPUT.PUT_LINE('L''age de l''etudiant ' || l_numEtu || ' est ' || l_ageEtu || '.');
END;
/


/*Partie 3*/
/*1*/
DECLARE
  CURSOR c_user_objets IS (SELECT object_name, object_type
                            FROM user_objects 
                            WHERE ((object_type = 'TABLE') OR (object_type = 'PROCEDURE') ) );
BEGIN
  FOR l_user_objets IN c_user_objets LOOP
    IF (l_user_objets.object_type = 'TABLE') THEN
      EXECUTE IMMEDIATE ( 'DROP '
        || l_user_objets.object_type || ' '
        || l_user_objets.object_name || ' CASCADE CONSTRAINTS');
    ELSE
      EXECUTE IMMEDIATE ('DROP '
        || l_user_objets.object_type || ' '
        || l_user_objets.object_name );
    END IF;
  END LOOP;
EXCEPTION 
  WHEN OTHERS THEN
    IF SQLCODE = -00942 THEN
      DBMS_OUTPUT.PUT_LINE('FAILED DROP TABLE');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Erreur Oracle ' || SQLERRM || '(' || SQLCODE || ')');
    END IF;
END;
/

/*2
Le code ci-dessus supprime toutes les tables du schéma.
DECLARE                                                       Déclaration de variable.
  CURSOR c_user_objets IS (SELECT object_name, object_type    Déclaration d'un curseur c_user_objets qui contient toutes lignes de la table user_objects où la valeur de la colonne object_type est TABLE.
  FROM user_objects WHERE object_type = 'TABLE');
BEGIN                                                         Début du bloc pl sql.
  FOR l_user_objets IN c_user_objets LOOP                     Boucle itérant pour chaque ligne renvoyé par le curseur.
    EXECUTE IMMEDIATE ( 'DROP '                               On supprime l'objet_type de nom object_name(une table) en cascade.
    || l_user_objets.object_type || ' '
    || l_user_objets.object_name || ' CASCADE CONSTRAINTS');
  END LOOP;                                                   Fin itération.
END;                                                          Fin du bloc pl sql.
*/

/*3
EXCEPTION 
  WHEN OTHERS THEN
    IF SQLCODE = -00942 THEN
      DBMS_OUTPUT.PUT_LINE('FAILED DROP TABLE');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Erreur Oracle ' || SQLERRM || '(' || SQLCODE || ')');
    END IF;
END;*/

/*4*/
DECLARE
  CURSOR c_user_objets IS (SELECT object_name, object_type
                            FROM user_objects 
                            WHERE ((object_type = 'TABLE') OR (object_type = 'PROCEDURE') ) );
BEGIN
  FOR l_user_objets IN c_user_objets LOOP
    BEGIN
      IF (l_user_objets.object_type = 'TABLE') THEN
        EXECUTE IMMEDIATE ( 'DROP '
          || l_user_objets.object_type || ' '
          || l_user_objets.object_name || ' CASCADE CONSTRAINTS');
      ELSE
        EXECUTE IMMEDIATE ('DROP '
          || l_user_objets.object_type || ' '
          || l_user_objets.object_name );
      END IF;
      EXCEPTION 
        WHEN OTHERS THEN
          IF SQLCODE = -00942 THEN
            DBMS_OUTPUT.PUT_LINE('FAILED DROP TABLE');
          ELSE
            DBMS_OUTPUT.PUT_LINE('Erreur Oracle ' || SQLERRM || '(' || SQLCODE || ')');
          END IF;
    END;
  END LOOP;
END;
/