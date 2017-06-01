defmodule Wo.Repo.Migrations.AddSearchDocumentTriggersToSermons do
  use Ecto.Migration

  def change do
    execute """
    CREATE OR REPLACE FUNCTION insert_sermon_search_documents()
    RETURNS trigger AS
            $BODY$
            BEGIN
                INSERT INTO search_documents(document_table, document_id, language, content)
                VALUES(TG_TABLE_NAME, NEW.id, 'english', setweight(to_tsvector('english', NEW.title), 'A') ||
                                                         setweight(to_tsvector('english', NEW.description), 'C') ||
                                                         setweight(to_tsvector('english', NEW.passage), 'D'));
                RETURN NEW;
            END;
            $BODY$
    LANGUAGE plpgsql VOLATILE;
    """

    execute """
    CREATE TRIGGER insert_sermon_search_documents
    AFTER INSERT ON sermons
    FOR EACH ROW EXECUTE PROCEDURE insert_sermon_search_documents();
    """

    execute """
    CREATE OR REPLACE FUNCTION delete_sermon_search_documents()
    RETURNS trigger AS
            $BODY$
            BEGIN
                DELETE FROM search_documents WHERE document_id = OLD.id;
                RETURN OLD;
            END;
            $BODY$
    LANGUAGE plpgsql VOLATILE;
    """

    execute """
    CREATE TRIGGER delete_search_documents
    BEFORE DELETE ON sermons
    FOR EACH ROW EXECUTE PROCEDURE delete_sermon_search_documents();
    """

    execute """
    CREATE OR REPLACE FUNCTION update_sermon_search_documents()
    RETURNS trigger AS
            $BODY$
            BEGIN
                UPDATE search_documents SET content = setweight(to_tsvector('english', NEW.title), 'A') ||
                                                      setweight(to_tsvector('english', NEW.description), 'C') ||
                                                      setweight(to_tsvector('english', NEW.passage), 'D');
                RETURN NEW;
            END;
            $BODY$
    LANGUAGE plpgsql VOLATILE;
    """

    execute """
    CREATE TRIGGER update_search_documents
    AFTER UPDATE ON sermons
    FOR EACH ROW EXECUTE PROCEDURE update_sermon_search_documents();
    """
  end
end
