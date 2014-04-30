--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Control.Arrow                   ((&&&))
import           Control.Monad                   (foldM, forM, forM_)
import           Data.Char                       (toLower)
import           Data.List                       (intercalate, intersperse,
                                                  sortBy)
import qualified Data.Map                        as M
import           Data.Maybe                      (catMaybes, fromMaybe)
import           Data.Monoid                     (mappend, mconcat, (<>))
import           Data.Monoid                     (mconcat)
import           Data.Ord                        (comparing)
import           Hakyll.Web.Pandoc
import           Hakyll
import           System.FilePath                 (takeBaseName, takeDirectory)
import           Text.Blaze.Html                 (toHtml, toValue, (!))
import           Text.Blaze.Html.Renderer.String (renderHtml)
import qualified Text.Blaze.Html5                as H
import qualified Text.Blaze.Html5.Attributes     as A
import           Text.Pandoc

--------------------------------------------------------------------------------

mathJaxScr = unlines ["<script type=\"text/javascript\" ",
                      "src=\"http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML\">",
                      "</script>"]

sidebarList :: [Identifier]
sidebarList = [ "about.md",
                "contact.md",
                "notes.md",
                "pe.md",
                "programming.md",
                "resume.md" ]

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

    -- Default template
    match (fromList sidebarList) $ do
        route   $ setExtension "html"
        compile $ pandocCompilerWith defaultHakyllReaderOptions pandocOptions 
            >>= loadAndApplyTemplate "templates/default.html" (mathCtx `mappend` defaultContext)
            >>= relativizeUrls
    match "templates/*" $ compile templateCompiler

    -- Post list (replaces archives)
    create ["posts.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let ctx = constField "title" "Posts" <>
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

--------------------------------------------------------------------------------
