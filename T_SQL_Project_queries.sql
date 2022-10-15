-----TP 420-BD1-BB INITIATION � LA FONCTION DE TRAVAIL

-------" Ententes achats accord�es �, http://donnees.ville.montreal.qc.ca/

-- ajouter des scripts pour nettoyer les donn�es -------
------------- Nombre total d'ententes de service---------------
SELECT COUNT()
FROM ENTENTES_ACHATS_ACCORDEES;
------------- 1.Nombre d'ententes de service par fornisseur ordonn�s par ordre decroissant---------------
SELECT NOM_FOURNISSEUR,
  COUNT() AS nbr_entente
FROM ENTENTES_ACHATS_ACCORDEES
GROUP BY NOM_FOURNISSEUR
ORDER BY nbr_entente DESC;
------------- 2.Nombre d'ententes maximum de service par fornisseur---------------
SELECT MAX(COUNT()) AS nbr_entente
FROM ENTENTES_ACHATS_ACCORDEES
GROUP BY NOM_FOURNISSEUR;
------------- 3.Le ou les fournisseurs ayant le maximum du nombre d'ententes de service---------------
SELECT NOM_FOURNISSEUR,
  COUNT() AS nbr_entente
FROM ENTENTES_ACHATS_ACCORDEES
GROUP BY NOM_FOURNISSEUR
HAVING COUNT(       )=
  (SELECT MAX(COUNT()) AS nbr_entente
  FROM ENTENTES_ACHATS_ACCORDEES
  GROUP BY NOM_FOURNISSEUR
  );
------------- 4.Le ou les fournisseurs ayant le minimum du nombre d'ententes de service---------------
SELECT NOM_FOURNISSEUR,
  COUNT() AS nbr_entente
FROM ENTENTES_ACHATS_ACCORDEES
GROUP BY NOM_FOURNISSEUR
HAVING COUNT(       )=
  (SELECT MIN(COUNT()) AS nbr_entente
  FROM ENTENTES_ACHATS_ACCORDEES
  GROUP BY NOM_FOURNISSEUR
  );
------------- 5.Les top 10 fournisseurs ayant le nombre elev� d'ententes de service---------------
SELECT 
FROM
  (SELECT NOM_FOURNISSEUR,
    COUNT() AS nbr_entente
  FROM ENTENTES_ACHATS_ACCORDEES
  GROUP BY NOM_FOURNISSEUR
  ORDER BY nbr_entente DESC
  )
WHERE rownum=10;
------------ 6.Nombre d'entente par statut ----------
SELECT STATUT_ENTENTE,
  COUNT() AS nbr_entente
FROM ENTENTES_ACHATS_ACCORDEES
GROUP BY STATUT_ENTENTE;
------------ 7.Nombre d'entente par par fournisseur et par statut ----------
SELECT NOM_FOURNISSEUR,
  STATUT_ENTENTE,
  COUNT() AS nbr_entente
FROM ENTENTES_ACHATS_ACCORDEES
GROUP BY NOM_FOURNISSEUR,
  STATUT_ENTENTE;
------------ 8.Liste d'entente de service ouvert  ----------
SELECT NOM_FOURNISSEUR,
  STATUT_ENTENTE,
  COUNT() AS nbr_entente
FROM ENTENTES_ACHATS_ACCORDEES
GROUP BY NOM_FOURNISSEUR,
  STATUT_ENTENTE;
------------ 9.Montant moyen des ententes  ----------
SELECT AVG(montant_total_convenu) AS moyenne_des_ententes
FROM ententes_achats_accordees;
------------ 10.top 10 des montants convenus  ----------
SELECT 
FROM
  (SELECT NUMERO_ENTENTE,
    NOM_FOURNISSEUR,
    MONTANT_TOTAL_CONVENU
  FROM ENTENTES_ACHATS_ACCORDEES
  ORDER BY MONTANT_TOTAL_CONVENU DESC
  )
WHERE rownum=10;
------------ 11.top 10 des services  ----------
SELECT 
FROM
  (SELECT DESCRIPTION_ENTENTE,
    COUNT(NUMERO_ENTENTE) AS nbr_entente
  FROM ENTENTES_ACHATS_ACCORDEES
  GROUP BY DESCRIPTION_ENTENTE
  ORDER BY nbr_entente DESC
  )
WHERE rownum=10;
------------ 12.top 10 des services  ----------
------ A completer ------------
SELECT 
FROM
  (SELECT DESCRIPTION_ENTENTE,
    COUNT(NUMERO_ENTENTE) AS nbr_entente
  FROM ENTENTES_ACHATS_ACCORDEES
  WHERE YEAR (DATE_DEBUT_ENTENTE)
  )=2020
GROUP BY DESCRIPTION_ENTENTE
ORDER BY nbr_entente DESC) WHERE rownum=10;
------ 13.cherche une entente selon un mot cl� ----------
SELECT numero_entente,
  numero_appel_offre,
  description_entente,
  numero_fournisseur,
  statut_entente
FROM ententes_achats_accordees
WHERE description_entente LIKE '%service%';
------- 14.la fonction analyique qui presente la liste des fournisseur
---et numero d'entente,  groupe par numero de fournisseur et decoupe par le status d'entente
SELECT numero_entente,
  numero_fournisseur,
  nom_fournisseur,
  statut_entente,
  dense_rank() over (partition BY statut_entente order by numero_fournisseur ) AS rownb_value
FROM ententes_achats_accordees;
----------15. calculation du lonqueur de la collabration avec les fournisseurs differents
SELECT numero_entente,
  numero_fournisseur,
  nom_fournisseur,
  statut_entente,
  ROUND(months_between(sysdate, date_debut_entente)12,1) AS years_with_company
FROM ententes_achats_accordees;
---------- 16.presentation de la liste des fournisseurs en utilisant de la fonction  case
SELECT numero_entente,
  numero_fournisseur,
  statut_entente,
  CASE
    WHEN length_of_cooperation  9
    THEN 'about  10 years'
    WHEN length_of_cooperation  5
    THEN 'over 5 years'
    WHEN length_of_cooperation  5
    THEN 'less than 5 years'
  END coop_group
FROM
  (SELECT numero_entente,
    numero_fournisseur,
    nom_fournisseur,
    statut_entente,
    months_between(date_fin_entente,date_debut_entente)12 AS length_of_cooperation
  FROM ententes_achats_accordees
  );
-------17. presentation de la liste des fournisseurs groupe par la duree de collabration
SELECT numero_fournisseur,
  ROUND(AVG(length_of_cooperation),2) AS history_of_cooperation
FROM
  (SELECT numero_entente,
    numero_fournisseur,
    nom_fournisseur,
    statut_entente,
    months_between(date_fin_entente,date_debut_entente)12 AS length_of_cooperation
  FROM ententes_achats_accordees
  )
GROUP BY numero_fournisseur
ORDER BY history_of_cooperation DESC;
------- 18.presentation de plus vieux et plus nouveau fournisseurs
SELECT MAX(history_of_cooperation),
  MIN(history_of_cooperation)
FROM
  (SELECT numero_fournisseur,
    ROUND(AVG(length_of_cooperation),2) AS history_of_cooperation
  FROM
    (SELECT numero_entente,
      numero_fournisseur,
      nom_fournisseur,
      statut_entente,
      months_between(date_fin_entente,date_debut_entente)12 AS length_of_cooperation
    FROM ententes_achats_accordees
    )
  GROUP BY numero_fournisseur
  ORDER BY history_of_cooperation DESC
  );
