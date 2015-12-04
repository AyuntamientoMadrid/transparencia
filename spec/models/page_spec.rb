require 'rails_helper'

feature Page do

  let!(:page)  { build(:page) }

  describe "link_xor_content" do

    before do
      page.link = "http://www.external-link.com"
      page.content = "Lorem ipsum"
    end

    it 'should return error when both filled' do
      expect(page).not_to be_valid
      expect(page.errors).to include (:link)
      expect(page.errors.messages[:link]).to include ("no puede crear una página que contenga un enlace externo y contenido. Rellene sólo uno de los dos campos.")
    end
  end

  describe "shpold have link or content on depth 3 nodes" do

    let!(:page1)  { create(:page) }
    let!(:page2)  { create(:page, parent: page1) }
    let!(:page3)  { create(:page, parent: page2) }
    let!(:page4)  { build(:page, parent: page3) }

    it 'should return error when both filled' do
      expect(page4).not_to be_valid
      expect(page4.errors).to include (:link)
      expect(page4.errors.messages[:link]).to include ("tiene que añadir un enlace externo o contenido a la página. Rellene uno de los dos campos.")
    end
  end

  describe "link" do

    before do
      page.link = "badlink"
    end

    it 'should not be valid with wrong link url' do
      expect(page).not_to be_valid
      expect(page.errors).to include (:link)
      expect(page.errors.messages[:link]).to include ("el enlace introducido no es válido")
    end
  end

  describe "level" do
    let!(:page1)  { create(:page) }
    let!(:page2)  { create(:page, parent: page1) }
    let!(:page3)  { create(:page, parent: page2) }
    let!(:page4)  { create(:page, parent: page3, link: "http://www.external-link.com") }

    it 'should return 1 for root nodes' do
      expect(page1.level).to eq(1)
    end

    it 'should return 2 for root nodes' do
      expect(page2.level).to eq(2)
    end

    it 'should return 3 for root nodes' do
      expect(page3.level).to eq(3)
    end

    it 'should return 4 for root nodes' do
      expect(page4.level).to eq(4)
    end
  end

  describe "search" do

    context "attributes" do

      it "searches by title" do
        page = create(:page, title: 'save the world')
        results = search('save the world')
        expect(results).to eq([page])
      end

      it "searches by subtitle" do
        page = create(:page, subtitle: 'basically...')
        results = search('basically')
        expect(results).to eq([page])
      end

      it "searches by content" do
        page = create(:page, content: 'in order to save the world one must think about...')
        results = search('one must think')
        expect(results).to eq([page])
      end

    end

    context "any word" do

      it "searches any word" do
        page = create(:page, title: 'save the world')
        results = search('save the earth')
        expect(results).to eq([page])

        results = search('world to be')
        expect(results).to eq([page])
      end
    end

    context "stemming" do

      it "searches word stems" do
        page = create(:page, title: 'plan')

        results = search('planificación')
        expect(results).to eq([page])

        results = search('planificar')
        expect(results).to eq([page])

        results = search('planificamos')
        expect(results).to eq([page])
      end

    end

    context "accents" do

      it "searches with accents" do
        page = create(:page, title: 'difusión')

        results = search('difusion')
        expect(results).to eq([page])

        page2 = create(:page, title: 'estadisticas')
        results = search('estadísticas')
        expect(results).to eq([page2])
      end

    end

    context "case" do

      it "searches case insensite" do
        page = create(:page, title: 'SHOUT')

        results = search('shout')
        expect(results).to eq([page])

        page2 = create(:page, title: "scream")
        results = search("SCREAM")
        expect(results).to eq([page2])
      end

    end

    context "typos" do

      it "searches with typos" do
        page = create(:page, title: 'difusión')

        results = search('difuon')
        expect(results).to eq([page])

        page2 = create(:page, title: 'desarrollo')
        results = search('desarolo')
        expect(results).to eq([page2])
      end

    end

    context "order" do

      it "orders by similarity" do
        similar   = create(:page, title: 'stop corruption')
        exact     = create(:page, title: 'stop corruption in the world')
        divergent = create(:page, title: 'reduce corruption in my city')

        results = search('stop corruption in the world')

        expect(results.first).to eq(exact)
        expect(results.second).to eq(similar)
        expect(results.third).to eq(divergent)
      end

    end

    context "no results" do

      it "no words match" do
        page = create(:page, title: 'save world')

        results = search('destroy planet')
        expect(results).to eq([])
      end

      it "too many typos" do
        page = create(:page, title: 'fantastic')

        results = search('fratac')
        expect(results).to eq([])
      end

      it "too much stemming" do
        page = create(:page, title: 'reloj')

        results = search('superreloimetroasdfa')
        expect(results).to eq([])
      end

      it "empty" do
        page = create(:page, title: 'great')

        results = search('')
        expect(results).to eq([])
      end

    end

  end

end