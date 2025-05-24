class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.34.6.tar.gz"
  sha256 "2bb6fda065c25a04a4a15a7cbf6ec7fc8654e4214977e0387121c751af4b37f9"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6f348664f1c9687f9d91c8ef750a88b43f51e2f06b5bb522ff8154d95057d51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bac01bae8be6787682ac92d8078f42bd9ebd19f50ce556244709600da41e1a3c"
    sha256 cellar: :any_skip_relocation, ventura:       "1296f22293fc459b16d9129e0b25e3a1fe0673c2b9b55febb4d8c360994a9945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e376871b688bc6f9c3fd756e1e87c57980bf0e0c482951657a468fd37ff950b8"
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
