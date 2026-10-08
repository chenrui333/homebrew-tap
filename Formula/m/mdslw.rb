# framework: clap
class Mdslw < Formula
  desc "Prepare your markdown for easy diff'ing"
  homepage "https://github.com/razziel89/mdslw"
  url "https://github.com/razziel89/mdslw/archive/refs/tags/0.18.0.tar.gz"
  sha256 "4a6bb638a6632ce9a75aa6d4b02cb7c987432068e0f91b970fa9cc20392d7d36"
  license "GPL-3.0-or-later"
  head "https://github.com/razziel89/mdslw.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1217bd7f0f05654522eefa9a709fc5732cdc325dd94c6532cb257d7690371382"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5462581985f71bb4db8f8ed7c9386b51c689a9746ee0bbcc052627d3caa6ebe2"
    sha256 cellar: :any,                 arm64_linux:   "200ac9ea9d360033da2b6ecacbe23f6caf80b40437d25f66ff1bedb959fb9c57"
    sha256 cellar: :any,                 x86_64_linux:  "e6a8a62a5d4b550f6813c5d410f737c4bf0fbbbaaf56db2c408fc89855514b40"
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
