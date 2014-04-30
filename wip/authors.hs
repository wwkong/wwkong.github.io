--------------------------------------------------------------------------------
data Authors = Authors
    { atuhorsMap        :: [(String, [Identifier])]
    , authorsMakeId     :: String -> Identifier
    , authorsDependency :: Dependency
    } deriving (Show)

simpleRenderLink :: String -> (Maybe FilePath) -> Maybe H.Html
simpleRenderLink _   Nothing         = Nothing
simpleRenderLink tag (Just filePath) =
  Just $ H.a ! A.href (toValue $ toUrl filePath) $ toHtml tag

getAuthors :: MonadMetadata m => Identifier -> m [String]
getAuthors identifier = do
    metadata <- getMetadata identifier
    return $ maybe [] (map trim . splitAll ",") $ M.lookup "author" metadata

buildAuthors :: MonadMetadata m => Pattern -> (String -> Identifier) -> m Authors
buildAuthors = buildAuthorsWith getAuthors

buildAuthorsWith :: MonadMetadata m
              => (Identifier -> m [String])
              -> Pattern
              -> (String -> Identifier)
              -> m Authors
buildAuthorsWith f pattern makeId = do
    ids    <- getMatches pattern
    tagMap <- foldM addTags M.empty ids
    return $ Authors (M.toList tagMap) makeId (PatternDependency pattern ids)
  where
    -- Create a tag map for one page
    addTags tagMap id' = do
        tags <- f id'
        let tagMap' = M.fromList $ zip tags $ repeat [id']
        return $ M.unionWith (++) tagMap tagMap'

authorsFieldWith :: (Identifier -> Compiler [String])
              -- ^ Get the authors
              -> (String -> (Maybe FilePath) -> Maybe H.Html)
              -- ^ Render link for one tag
              -> ([H.Html] -> H.Html)
              -- ^ Concatenate tag links
              -> String
              -- ^ Destination field
              -> Authors
              -- ^ Authors structure
              -> Context a
              -- ^ Resulting context
authorsFieldWith getTags' renderLink cat key authors = field key $ \item -> do
    tags' <- getTags' $ itemIdentifier item
    links <- forM tags' $ \tag -> do
        route' <- getRoute $ authorsMakeId authors tag
        return $ renderLink tag route'
    return $ renderHtml $ cat $ catMaybes $ links

-- | Render authors with links
authorsField :: String     -- ^ Destination key
          -> Authors       -- ^ Authors
          -> Context a  -- ^ Context
authorsField =
  authorsFieldWith getAuthors simpleRenderLink (mconcat . intersperse ", ")

renderTags :: (String -> String -> Int -> Int -> Int -> String)
           -- ^ Produce a tag item: tag, url, count, min count, max count
           -> ([String] -> String)
           -- ^ Join items
           -> Tags
           -- ^ Tag cloud renderer
           -> Compiler String
renderTags makeHtml concatHtml tags = do
    -- In tags' we create a list: [((tag, route), count)]
    tags' <- forM (tagsMap tags) $ \(tag, ids) -> do
        route' <- getRoute $ tagsMakeId tags tag
        return ((tag, route'), length ids)

    -- TODO: We actually need to tell a dependency here!

    let -- Absolute frequencies of the pages
        freqs = map snd tags'

        -- The minimum and maximum count found
        (min', max')
            | null freqs = (0, 1)
            | otherwise  = (minimum &&& maximum) freqs

        -- Create a link for one item
        makeHtml' ((tag, url), count) =
            makeHtml tag (toUrl $ fromMaybe "/" url) count min' max'

    -- Render and return the HTML
    return $ concatHtml $ map makeHtml' tags

renderAuthorList :: Authors -> Compiler (String)
renderAuthorList = renderTags makeLink (intercalate ", ")
  where
    makeLink tag url count _ _ = renderHtml $
        H.a ! A.href (toValue url) $ toHtml (tag ++ " (" ++ show count ++ ")")

--------------

postCtxTA :: Tags -> Authors -> Context String
postCtxTA tags authors = authorsField "authors" authors `mappend` postCtxTags tags

----- Build authors
authors <- buildAuthors "posts/*" (fromCapture "authors/*.html")