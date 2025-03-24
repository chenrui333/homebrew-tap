class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "fda9b5bbb63a5835b0acce16feb75b86b375c3c29b8b333d5e4f414d686e8dea"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "809fd32c66ad9b6b42def9d664fb40f745383f7e2922f9a83873dc7b7b359962"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12e2fcd3a85523390af279f6e1c5f7710d32cca5cd45bc4ff80780d14a99a770"
    sha256 cellar: :any_skip_relocation, ventura:       "be86877a857bb0a5a7954c6d5eb055c09e6d2fdfd77c50199866c029baf82d51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a2a0f09b579b5137bd0747b0697f18f919707cd438175a7477452cf413d2884"
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
