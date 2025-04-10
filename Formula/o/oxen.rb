class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.32.5.tar.gz"
  sha256 "1098ada272fb1bd711131601330f26353aec6901855ee8e2d83621d617128e73"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2861e985155f0671672647ab6c98368c87d20ee854a4682cb6462fb7e2dbbc0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecb257102b15bfe1fbbb7459b1a0bf4964b4f266e90ffe0744d7127e8379bb6c"
    sha256 cellar: :any_skip_relocation, ventura:       "aa0b37eeee3e686635181211dff44b030258f9b0a0b20d9aeca34981ee60b3fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "371ef591e7816c52001ceb3fc508c291914f99105dd9d108cb7e253d3569f99b"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end
