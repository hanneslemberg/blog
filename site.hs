--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import Data.Monoid (mappend, (<>))
import Hakyll
import System.FilePath.Posix  (takeBaseName,takeDirectory,(</>),splitFileName, joinPath, splitPath, replaceExtension)


--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" <>
    siteCtx

siteCtx :: Context String
siteCtx =
    constField "base_url" "/" <>
    constField "site_title" "Links & Snippets" <>
    defaultContext
-------------
imageMacro :: [String] -> Item a -> Compiler String
imageMacro args item = return $ concat args

dropContentPart = joinPath . drop 1 . splitPath . toFilePath

staticRoute :: Identifier -> FilePath
staticRoute = dropContentPart

postRoute :: Identifier -> FilePath
postRoute =  postRoute' . dropContentPart
  where postRoute' path =
         let dir = takeDirectory $ path
         in dir </> takeBaseName path </> "index.html"

rootRoute :: Identifier -> FilePath
rootRoute =  flip replaceExtension "html" . dropContentPart


main :: IO ()
main = hakyll $ do
    match "content/static/*/*" $ do
      route (customRoute staticRoute)
      compile copyFileCompiler
    match "content/posts/*.md" $ do
      route (customRoute postRoute)
      compile $ pandocCompiler
          >>= loadAndApplyTemplate "layouts/page.html" siteCtx
          >>= loadAndApplyTemplate "layouts/default.html" siteCtx
    match "content/*.md" $ do
        route (customRoute rootRoute)
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "layouts/page.html" siteCtx
            >>= loadAndApplyTemplate "layouts/default.html" siteCtx
    create ["posts/index.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "content/posts/*.md"
            let archiveCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Archive"            `mappend`
                    siteCtx
            makeItem ""
                >>= loadAndApplyTemplate "layouts/archive.html" archiveCtx
                >>= loadAndApplyTemplate "layouts/default.html" archiveCtx
                >>= relativizeUrls
    match "layouts/*" $ compile templateCompiler

{-
    create ["archive.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let archiveCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Archives"            `mappend`
                    siteCtx

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls


    match "index.html" $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let indexCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Home"                `mappend`
                    siteCtx
            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls
-}
