--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import qualified Data.Map            as M
import           Data.Monoid
import qualified Data.Set            as S
import           GHC.IO.Encoding
import           Hakyll
import           Text.Pandoc
import           Text.Pandoc.Options

--------------------------------------------------------------------------------

sidebarList :: [Identifier]
sidebarList = [ "contact.md",
                "notes.md",
                "pe.md",
                "programming.md" ]

myFeedConfiguration :: FeedConfiguration
myFeedConfiguration = FeedConfiguration
    { feedTitle       = "wwkong.github.io"
    , feedDescription = "A blend of mathematics, finance, and computer science."
    , feedAuthorName  = "William Kong"
    , feedAuthorEmail = "wwkong92@gmail.com"
    , feedRoot        = "http://wwkong.github.io/"
    }

pandocMathCompiler =
        let writerOptions = defaultHakyllWriterOptions {
                          writerExtensions = writerExtensions defaultHakyllWriterOptions,
                          writerHTMLMathMethod = MathJax ""
                        }
        in pandocCompilerWith defaultHakyllReaderOptions writerOptions

--pandocMathCompiler = pandocCompilerWith defaultHakyllReaderOptions defaultHakyllWriterOptions

--------------------------------------------------------------------------------

baseCtx :: Context String
baseCtx = dateField "date" "%B %e, %Y" `mappend` defaultContext

postCtxTags :: Tags -> Context String
postCtxTags tags = tagsField "tags" tags `mappend` baseCtx

archivesCtx :: Tags -> [Item String] -> Context String
archivesCtx tags posts =
    constField "title" "Archive" <>
    listField "posts" (postCtxTags tags) (return posts) <>
    field "tags" (\_ -> renderTagList tags) <>
    postCtxTags tags



--------------------------------------------------------------------------------
main :: IO ()
main = do
    
    -- Set UTF-8 Encoding
    setLocaleEncoding utf8
    setFileSystemEncoding utf8
    setForeignEncoding utf8

    hakyll $ do

    -- Basic folders
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match "files/*" $ do
        route   idRoute
        compile copyFileCompiler    

    -- Build tags
    tags <- buildTags "posts/*" (fromCapture "tags/*.html")

    -- Create posts
    match "posts/*" $ do
        route   $ setExtension ".html"
        compile $ do
            pandocMathCompiler
                >>= saveSnapshot "content"
                >>= return . fmap demoteHeaders
                >>= loadAndApplyTemplate "templates/post.html"      (postCtxTags tags)
                >>= loadAndApplyTemplate "templates/default.html"   (postCtxTags tags)
                >>= relativizeUrls

    -- Home page
    match "index.html" $ do
        route idRoute
        compile $ do
            posts <- fmap (take 3) . recentFirst =<< loadAll "posts/*"
            getResourceBody
                >>= applyAsTemplate (archivesCtx tags posts)
                >>= loadAndApplyTemplate "templates/default.html" (archivesCtx tags posts)
                >>= relativizeUrls

    -- Achives
    match "archive.html" $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            getResourceBody
                >>= applyAsTemplate (archivesCtx tags posts)
                >>= loadAndApplyTemplate "templates/default.html" (archivesCtx tags posts)
                >>= relativizeUrls

    -- Default template and other basic pages
    match (fromList sidebarList) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" baseCtx
            >>= relativizeUrls

    -- Resume page
    match "resume.md" $ do
        route   $ setExtension ".html"
        compile $ do
            cvTpl      <- loadBody "templates/resume.html"
            defaultTpl <- loadBody "templates/default.html"
            pandocCompiler
                >>= applyTemplate cvTpl         baseCtx
                >>= applyTemplate defaultTpl    baseCtx
                >>= relativizeUrls

    -- Post list
    create ["posts.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            makeItem ""
                >>= loadAndApplyTemplate "templates/tag.html"     (archivesCtx tags posts)
                >>= loadAndApplyTemplate "templates/default.html" (archivesCtx tags posts)
                >>= relativizeUrls

    -- Post tags
    tagsRules tags $ \tag pattern -> do
        let title = "Posts tagged " ++ tag
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll pattern
            makeItem ""
                >>= loadAndApplyTemplate "templates/tag.html"     (archivesCtx tags posts)
                >>= loadAndApplyTemplate "templates/default.html" (archivesCtx tags posts)
                >>= relativizeUrls

    --- Atom Feed
    create ["atom.xml"] $ do
    route idRoute
    compile $ do
        let feedCtx = baseCtx `mappend` bodyField "description"
        posts <- fmap (take 10) . recentFirst =<<
            loadAllSnapshots "posts/*" "content"
        renderAtom myFeedConfiguration feedCtx posts

    -- Render Templates
    match "templates/*" $ compile templateCompiler

--------------------------------------------------------------------------------