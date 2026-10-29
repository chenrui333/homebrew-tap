class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.28.3.tar.gz"
  sha256 "4755075bcdc4a4720448e6dbf564e4ba6b50bb88efdaa98123e5fbdc5dba1a32"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48e438d05080caf81277d266c4509854c808cb5a77f8ecb0bad80498ff7d4a74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "675c04626b94b0889b6c32b7e7f6be826e65ec8964baa3f4dc507eaf04f231df"
    sha256 cellar: :any,                 arm64_linux:   "97eea80e878f67bbe1c87d35970fafbc58485d0142a91b072d402198a57e2cac"
    sha256 cellar: :any,                 x86_64_linux:  "0c7ca57fb489aead9378154a45c764577ec41ac7ebead38ee9ac91cd3ced862a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "libssh2"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "parallel", because: "both install a sem executable"

  deny_network_access!

  def fetch
    cd "crates" do
      system "cargo", "fetch", *std_cargo_fetch_args
    end
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "crates/sem-cli"), "--no-default-features"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sem --version")

    system "git", "init"
    system "git", "config", "user.email", "test@example.com"
    system "git", "config", "user.name", "Test User"
    (testpath/"hello.py").write <<~PYTHON
      def greet():
          print("hello")
    PYTHON
    system "git", "add", "hello.py"
    system "git", "commit", "-m", "init"

    output = shell_output("#{bin}/sem diff --commit HEAD --format json")
    json = JSON.parse(output)
    assert_equal 1, json["changes"].length
    assert_equal "function", json["changes"][0]["entityType"]
    assert_equal "greet", json["changes"][0]["entityName"]
  end
end
