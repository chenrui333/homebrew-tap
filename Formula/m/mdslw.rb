# framework: clap
class Mdslw < Formula
  desc "Prepare your markdown for easy diff'ing"
  homepage "https://github.com/razziel89/mdslw"
  url "https://github.com/razziel89/mdslw/archive/refs/tags/0.17.2.tar.gz"
  sha256 "e290f36a321da01f0135f37e2c98ff95e0317c1a024b074c5320ac15fe11798c"
  license "GPL-3.0-or-later"
  head "https://github.com/razziel89/mdslw.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3fb911b46f0d916ffe04a9538af547445c600676d7d3e82b8b76de830a1324d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6484004351ef8ef1a7bf226758d5f6977ffde259f719e6e8ed2c601c1251247"
    sha256 cellar: :any,                 arm64_linux:   "f1cbe06bde28454fd3b371e441f36e9f948d78a93709ed43bcf082c59125c43b"
    sha256 cellar: :any,                 x86_64_linux:  "a8c63fa3a8b09a4ba63a3c5c033ca48a9ce3d855dd67416674be25955b55ed2a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  # Homebrew-specific: build.rs downloads CLDR sentence-break suppressions from the
  # unpinned cldr-json main branch; pin them here so the build is offline and reproducible.
  # Languages match "Supported languages are:" in src/cfg.rs.
  resource "cldr-suppressions-de" do
    url "https://raw.githubusercontent.com/unicode-org/cldr-json/91c267402229a59e3ef2774544f001bf959e8809/cldr-json/cldr-segments-full/segments/de/suppressions.json"
    sha256 "5167ed91fe44a1731436a2504ad41031e4c11cf90911be3be5511d1d8eb94696"
  end

  resource "cldr-suppressions-en" do
    url "https://raw.githubusercontent.com/unicode-org/cldr-json/91c267402229a59e3ef2774544f001bf959e8809/cldr-json/cldr-segments-full/segments/en/suppressions.json"
    sha256 "2ff91fe1de2598489858f72c8156706cede8f17839aa0aab8070341bb47dc5b8"
  end

  resource "cldr-suppressions-es" do
    url "https://raw.githubusercontent.com/unicode-org/cldr-json/91c267402229a59e3ef2774544f001bf959e8809/cldr-json/cldr-segments-full/segments/es/suppressions.json"
    sha256 "e2727f33f3d5d4968fdb241d51482780472d8ba9382db43027395d3b99e83b86"
  end

  resource "cldr-suppressions-fr" do
    url "https://raw.githubusercontent.com/unicode-org/cldr-json/91c267402229a59e3ef2774544f001bf959e8809/cldr-json/cldr-segments-full/segments/fr/suppressions.json"
    sha256 "fbc211a2ff6a96636c69611d26962a3cccc7662f3dae561cd9e35bd5eabb4213"
  end

  resource "cldr-suppressions-it" do
    url "https://raw.githubusercontent.com/unicode-org/cldr-json/91c267402229a59e3ef2774544f001bf959e8809/cldr-json/cldr-segments-full/segments/it/suppressions.json"
    sha256 "a7e50b969074d2a2c4848bf671c4972b8f1cbbd2ef7ef551bf4bf3533b0983c6"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    cldr_dir = buildpath/"cldr"
    %w[de en es fr it].each { |lang| resource("cldr-suppressions-#{lang}").stage(cldr_dir/lang) }
    inreplace "build.rs", /reqwest::blocking::get\(format!\(.*?\.json::<Value>\(\)/m,
              "serde_json::from_str::<Value>(&fs::read_to_string(" \
              'Path::new(&env::var("MDSLW_CLDR_DIR").unwrap()).join(lang).join("suppressions.json"))' \
              '.expect("reading language"))'
    ENV["MDSLW_CLDR_DIR"] = cldr_dir

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdslw --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Title

      This is a test markdown file.

      ```python
      print( "Hello, World!" )
      ```
    MARKDOWN

    system bin/"mdslw", "test.md"
    expected_content = <<~MARKDOWN
      # Title

      This is a test markdown file.

      ```python
      print( "Hello, World!" )
      ```
    MARKDOWN

    assert_equal expected_content, (testpath/"test.md").read
  end
end
