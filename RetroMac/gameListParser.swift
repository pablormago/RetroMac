//
//  parserSystems.swift
//  RetroMac
//
//  Created by Pablo Jimenez on 03/12/2021.
//  Copyright © 2021 pmg. All rights reserved.
//

import Foundation

//
// MARK: - Estructuras -
//



public struct Game
{
    //Nombre de archivo. Ojo con "./"
    public var path : String = ""
    /// El nombre del juego
    public var name : String = ""
    /// Descripción
    public var desc : String = ""
    ///Mapa del Juego
    public var map : String = ""
    ///Manual del Juego
    public var manual : String = ""
    ///Noticias del Juego??
    public var news : String = ""
    ///TittleShot del Juego
    public var tittleshot : String = ""
    ///Fanart del juego
    public var fanart: String = ""
    ///Thumbnail del juego
    public var thumbnail: String = ""
    ///Imagen del Juego
    public var image: String = ""
    ///Video del Juego
    public var video: String = ""
    ///Marquee del Juego
    public var marquee: String = ""
    ///Fecha de Lanzamiento
    public var releasedata: String = ""
    ///Developer del Juego
    public var developer: String = ""
    ///Publisher del Juego
    public var publisher: String = ""
    ///Genero
    public var genre: String = ""
    ///Lenguaje del Juego
    public var lang: String = ""
    ///Jugadores
    public var players: String = ""
    ///Rating del juego
    public var rating: String = ""
    
    public var fav: String = ""
}

//
// MARK: - Protocolos empleados durante el parseado -
//



public class GameParser: NSObject
{
    ///MARK: - TAGS -
    
    private let BooksSection = "gameList"
    private let BookSection = "game"
    
    private let PathTag = "path"
    private let NameTag = "name"
    private let DescTag = "desc"
    private let MapTag = "map"
    private let ManualTag = "manual"
    private let NewsTag = "news"
    private let TittleshotTag = "tittleshot"
    private let FanartTag = "fanart"
    private let ThumbnailTag = "thumbnail"
    private let ImageTag = "image"
    private let VideoTag = "video"
    private let MarqueeTag = "marquee"
    private let ReleasedataTag = "releasedata"
    private let DeveloperTag = "developer"
    private let PublisherTag = "publisher"
    private let GenreTag = "genre"
    private let LangTag = "lang"
    private let PlayersTag = "players"
    private let RatingTag = "rating"
    private let FavTag = "fav"
    
    
    
    
    /// Parser de XML
    private var parser: XMLParser
    /// Tag en la que nos encontramos en un momento dado
    private var actualElement: String
    /// El parser que está *activo* en este momento
    private var actualParser: XMLParserDelegate?
    
    ///
    private var actualBook: Game?
    ///
    internal private(set) var games: [Game]
    
    /**
     
    */
    public init(data: Data)
    {
        self.actualElement = ""
        self.games = [Game]()
        
        self.parser = XMLParser(data: data)
        
        super.init()
        
        // Delegado
        self.parser.delegate = self
        
        // Empezamos a parsear
        parser.parse()
    }
}

extension GameParser: XMLParserDelegate
{
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        switch elementName
        {
            case BookSection:
                self.actualBook = Game()
            
            
            
            default:
                self.actualElement = elementName
        }
    }
    
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if elementName == BookSection
        {
            if let actualBook = self.actualBook
            {
                self.games.append(actualBook)
            }
        }
        
        if elementName == BooksSection
        {
            self.parser.abortParsing()
        }
        
        self.actualElement = ""
    }
    
    public func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        if self.actualElement == PathTag
        {
            
            self.actualBook?.path.append(string)
        }
        
        if self.actualElement == NameTag
        {
            self.actualBook?.name.append(string)
        }
        
        
        if self.actualElement == DescTag
        {
            
            self.actualBook?.desc.append(string)
        }
        
        if self.actualElement == MapTag
        {
            
            self.actualBook?.map.append(string)
        }
        
        if self.actualElement == ManualTag
        {
            
            self.actualBook?.manual.append(string)
        }
        
        if self.actualElement == NewsTag
        {
            
            self.actualBook?.news.append(string)
        }
        
        if self.actualElement == TittleshotTag
        {
            
            self.actualBook?.tittleshot.append(string)
        }
        
        if self.actualElement == FanartTag
        {
            
            self.actualBook?.fanart.append(string)
        }
        
        if self.actualElement == ThumbnailTag
        {
            
            self.actualBook?.thumbnail.append(string)
        }
        
        if self.actualElement == ImageTag
        {
            
            self.actualBook?.image.append(string)
        }
        
        if self.actualElement == VideoTag
        {
            
            self.actualBook?.video.append(string)
        }
        
        if self.actualElement == MarqueeTag
        {
            
            self.actualBook?.marquee.append(string)
        }
        
        if self.actualElement == ReleasedataTag
        {
            
            self.actualBook?.releasedata.append(string)
        }
        
        if self.actualElement == DeveloperTag
        {
            
            self.actualBook?.developer.append(string)
        }
        
        if self.actualElement == PublisherTag
        {
            
            self.actualBook?.publisher.append(string)
        }
        
        if self.actualElement == GenreTag
        {
            
            self.actualBook?.genre.append(string)
        }
        
        if self.actualElement == LangTag
        {
            
            self.actualBook?.lang.append(string)
        }
        
        if self.actualElement == PlayersTag
        {
            
            self.actualBook?.players.append(string)
        }
        
        if self.actualElement == RatingTag
        {
            
            self.actualBook?.rating.append(string)
        }
        if self.actualElement == FavTag
        {
            
            self.actualBook?.fav.append(string)
        }
    }
    
    public func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data)
    {
        guard let stringValue = String(data: CDATABlock, encoding: .utf8) else
        {
            return
        }
        
        
    }
    
    public func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error)
    {
        //print("Book parsing error. \(parseError)")
    }
}


//
// MARK: - Test -
//

