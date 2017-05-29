defmodule Wo.Repo.Migrations.CreateSearchDocuments do
  use Ecto.Migration

  def change do
    create table(:search_documents) do
      add :document_table, :string
      add :document_id, :integer
      add :language, :string
      add :content, :tsvector
    end

    create unique_index(:search_documents, [:document_table, :document_id, :language])

    execute """
    CREATE OR REPLACE FUNCTION insert_search_documents()
    RETURNS trigger AS
            $BODY$
            BEGIN
                INSERT INTO search_documents(document_table, document_id, language, content)
                VALUES(TG_TABLE_NAME, NEW.id, 'english', setweight(to_tsvector('english', NEW.title), 'A') ||
                                                         setweight(to_tsvector('english', NEW.description), 'C'));
                RETURN NEW;
            END;
            $BODY$
    LANGUAGE plpgsql VOLATILE;
    """

    execute """
    CREATE TRIGGER insert_search_documents
    AFTER INSERT ON sermon_series
    FOR EACH ROW EXECUTE PROCEDURE insert_search_documents();
    """

    execute """
    CREATE OR REPLACE FUNCTION delete_search_documents()
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
    BEFORE DELETE ON sermon_series
    FOR EACH ROW EXECUTE PROCEDURE delete_search_documents();
    """

    execute """
    CREATE OR REPLACE FUNCTION update_search_documents()
    RETURNS trigger AS
            $BODY$
            BEGIN
                UPDATE search_documents SET content = setweight(to_tsvector('english', NEW.title), 'A') ||
                                                      setweight(to_tsvector('english', NEW.description), 'C');
                RETURN NEW;
            END;
            $BODY$
    LANGUAGE plpgsql VOLATILE;
    """

    execute """
    CREATE TRIGGER update_search_documents
    AFTER UPDATE ON sermon_series
    FOR EACH ROW EXECUTE PROCEDURE update_search_documents();
    """
  end
end
