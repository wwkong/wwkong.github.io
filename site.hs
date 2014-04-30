--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import qualified Data.Map    as M
import           Data.Monoid
import           Hakyll
import           Text.Pandoc


--------------------------------------------------------------------------------

mathJaxScr :: String
mathJaxScr = unlines ["<script type=\"text/javascript\" ",
                      "src=\"http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML\">",
                      "</script>"]

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

pandocOptions :: WriterOptions
pandocOptions = defaultHakyllWriterOptions{ writerHTMLMathMethod = MathJax "" }

--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    defaultContext

postCtxTags :: Tags -> Context String
postCtxTags tags = tagsField "tags" tags `mappend` postCtx

mathCtx :: Context a
mathCtx = field "mathjax" $ \item -> do
    metadata <- getMetadata $ itemIdentifier item
    return $ if "mathjax" `M.member` metadata
                  then mathJaxScr
                  else ""


--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do

    -- Basic folders
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "etc/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    -- Build tags
    tags <- buildTags "posts/*" (fromCapture "tags/*.html")

    -- Create posts
    match "posts/*" $ do
        route   $ setExtension ".html"
        compile $ do
            pandocCompilerWith defaultHakyllReaderOptions pandocOptions 
                >>= saveSnapshot "content"
                >>= return . fmap demoteHeaders
                >>= loadAndApplyTemplate "templates/post.html"      (mathCtx `mappend` postCtxTags tags)
                >>= saveSnapshot "content"
                >>= loadAndApplyTemplate "templates/default.html"   (mathCtx `mappend` postCtxTags tags)
                >>= relativizeUrls

    -- Home page
    match "index.html" $ do
        route idRoute
        compile $ do
            posts <- fmap (take 3) . recentFirst =<< loadAll "posts/*"
            let indexContext =
                    listField "posts" (postCtxTags tags) (return posts) <>
                    field "tags" (\_ -> renderTagList tags) <>
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexContext
                >>= loadAndApplyTemplate "templates/default.html" (mathCtx `mappend` indexContext)
                >>= relativizeUrls

    -- Default template and other basic pages
    match (fromList sidebarList) $ do
        route   $ setExtension "html"
        compile $ pandocCompilerWith defaultHakyllReaderOptions pandocOptions 
            >>= loadAndApplyTemplate "templates/default.html" (mathCtx `mappend` defaultContext)
            >>= relativizeUrls

    -- Resume page
    match "resume.md" $ do
        route   $ setExtension ".html"
        compile $ do
            cvTpl      <- loadBody "templates/resume.html"
            defaultTpl <- loadBody "templates/default.html"
            pandocCompiler
                >>= applyTemplate cvTpl 		(mathCtx `mappend` defaultContext)
                >>= applyTemplate defaultTpl 	(mathCtx `mappend` defaultContext)
                >>= relativizeUrls

    -- Post list (replaces archives)
    create ["posts.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let ctx = constField "title" "Archive" <>
                      listField "posts" (postCtxTags tags) (return posts) <>
                      defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/tag.html" (mathCtx `mappend` ctx)
                >>= loadAndApplyTemplate "templates/default.html" (mathCtx `mappend` ctx)
                >>= relativizeUrls

    -- Post tags
    tagsRules tags $ \tag pattern -> do
        let title = "Posts tagged " ++ tag
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll pattern
            let ctx = constField "title" title <>
                      listField "posts" (postCtxTags tags) (return posts) <>
                      defaultContext
            makeItem ""
                >>= loadAndApplyTemplate "templates/tag.html" (mathCtx `mappend` ctx)
                >>= loadAndApplyTemplate "templates/default.html" (mathCtx `mappend` ctx)
                >>= relativizeUrls

    --- Atom Feed
    create ["atom.xml"] $ do
    route idRoute
    compile $ do
        let feedCtx = postCtx `mappend` bodyField "description"
        posts <- fmap (take 10) . recentFirst =<<
            loadAllSnapshots "posts/*" "content"
        renderAtom myFeedConfiguration feedCtx posts

    -- Render Templates
    match "templates/*" $ compile templateCompiler

--------------------------------------------------------------------------------
