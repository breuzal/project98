    ## Création des cartes :
struct Carte 
    rang :: Int64
    couleur :: Int64 
    function Carte(rang::Int64, couleur::Int64) 
        @assert(1 ≤ rang ≤ 13, "problème de rang")
        @assert(1 ≤ couleur ≤ 4, "problème de couleur")
    new(rang, couleur)
    end 
end
# Créer une structure de carte renseignée par un couple d'entiers.
    # @assert : permet d'imposer une condition sur les valeurs prises par les arguments.
    # new : créer la carte si les conditions sont remplies.
    # Cette structure permet de classifier les cartes => pouvoir les comparer.

rangs = (:As, 2, 3, 4, 5, 6, 7, 8 , 9, 10, :V, :D, :R)
couleurs = (:♥, :♦, :♠, :♣)

function Base.show(io::IO, carte::Carte)
   print(io, rangs[carte.rang], couleurs[carte.couleur])
end
# Base.show : fonction show de base (au cas où elle est modifiée ailleurs).
# io :: IO : multiple dispatching : permet de gérer l'affichage automatiquement.
# io (dans print) : associer le show et le print.
# Cette fonction permet d'associer la structure de la carte à sa "vraie" valeur.

# Test :
Carte(12,1)
typeof(Carte(12,1))


    ## Création du paquet de cartes :
struct Paquet 
    cartes :: Array{Carte, 1} 
end
# Créer une structure pour le paquet de cartes.

function Paquet52() 
    paquet = Paquet(Carte[])
    for couleur in 1:4 
# Sélectionne la couleur de la carte.
        for rang in 1:13 
# Sélectionne le rang de la carte.
            push!(paquet.cartes, Carte(rang, couleur)) 
# push! : ajoute le couple carte sélectionné à la liste de cartes du paquet.
        end
    end
    paquet
end

# Le Paquet est pour le moment une liste de cartes.

function Base.show(io::IO, paquet::Paquet) 
    for carte in paquet.cartes
        print(io, carte, " ")
    end
    println()
end
# Cette fonction permet de créer un affichage pour les cartes de la liste stocker dans le Paquet.

Paquet52()
# Le paquet est maintenant composé de cartes séparées.



    ## Effets sur le paquet :
        # Mélanger le paquet :
using Random
function Random.shuffle!(paquet::Paquet)
    shuffle!(paquet.cartes)
    paquet
end
# Importe et formate la fonction "shuffle!" pour l'adapter au paquet.

pile = shuffle!(Paquet52())
# Créer la pile de cartes mélangées.
print("Pile = ", pile)


        # Sortir une carte :
function Base.pop!(paquet::Paquet) 
    pop!(paquet.cartes)
end
tirage = pop!(pile)
# Retire la dernière carte de la pile et l'affiche.
print("Tirage = ", tirage)
print("Nouvelle pile = ",pile)


        # Supprimer une carte :
function Base.splice!(paquet::Paquet, index::Int64)
    splice!(paquet.cartes, index)
end
# Supprime la carte d'indice index du paquet.


        # Ajouter une carte :
function Base.push!(paquet::Paquet, carte::Carte) 
    push!(paquet.cartes, carte)
    paquet 
end
# Rajoute une carte à la fin de paquet sélectionné.

recomp = push!(pile, tirage)
print("Recomposition = ", recomp)
# La carte tirée a été remise à la fin du paquet (à la place où elle a été tiré).


        # Créer les mains des joueurs en début de partie :
function distribution(paquet::Paquet, joueur::Paquet)
    for i in 1:5
        joueur = push!(joueur, pop!(paquet))
    end
    joueur
end
# La fonction transfert 5 cartes d'un "paquet" à un "joueur" et retourne la main du joueur.
# A la fin de la fonction, les 5 dernières cartes du "paquet" n'apparaissent donc plus (puisqu'elles sont dans la main du joueur).
# Le reste du "paquet sert alors de pioche.

paquet = shuffle!(Paquet52())
length(paquet.cartes)
joueur1 = Paquet(Carte[])
joueur2 = Paquet(Carte[])
joueur3 = Paquet(Carte[])
joueur4 = Paquet(Carte[])
# print("Paquet = ", paquet)
joueur1 = distribution(paquet, joueur1)
# print("Paquet = ", paquet)
joueur2 = distribution(paquet, joueur2)
# print("Paquet = ", paquet)
joueur3 = distribution(paquet, joueur3)
joueur4 = distribution(paquet, joueur4)
length(paquet.cartes)

joueur1.cartes[1]
# Permet d'appeler la première carte du joueur1.



# /!\ PB /!\

# Fonction splice! à revoir.

# Actions sur le compteur :
function jouer(compteur::Int64, carte::Carte, joueur::Paquet, defausse::Paquet, index::Int64)
    rg = carte.rang
    if 1 <= rg <= 10
        compteur += rg
    elseif rg == 11
        compteur += 0
    elseif rg == 12
        compteur -= 10
    elseif rg == 13
        compteur = 70
    end
    push!(defausse.cartes, carte)
    splice!(joueur.cartes, index)
    defausse
end

paquet = Paquet52()
joueur = Paquet(Carte[])
joueur = distribution(paquet, joueur)
compteur = 0
defausse = Paquet(Carte[])
compteur = jouer(compteur, joueur.cartes[5], joueur, defausse, 5)
compteur
joueur
defausse


paquet = Paquet52()
defausse = Paquet(Carte[])
push!(defausse.cartes, paquet.cartes[4])
splice!(paquet.cartes, 4)
defausse
paquet