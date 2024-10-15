include("structures.jl")


# Mélanger le paquet :
using Random
function Random.shuffle!(paquet::Paquet)
    shuffle!(paquet.cartes)
    paquet
end


# Tirer une carte :
function Base.pop!(paquet::Paquet) 
    pop!(paquet.cartes)
end


# Supprimer une carte à un endroit donné :
function Base.splice!(paquet::Paquet, index::Int64)
    splice!(paquet.cartes, index)
end


# Ajouter une carte :
function Base.push!(paquet::Paquet, carte::Carte) 
    push!(paquet.cartes, carte)
    paquet 
end


# Mise en place du jeu (mains des joueurs et pioche) :
function distribution(paquet::Paquet, joueur::Paquet)
    for i in 1:5
        joueur = push!(joueur, pop!(paquet))
    end
    joueur
end


# Actions sur le compteur :
function jouer(compteur, carte::Carte)
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
end