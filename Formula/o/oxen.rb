class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.28.1.tar.gz"
  sha256 "75b44ce3513afba862c1456e8c00314a9c2c00e927d20171bf895c240edcd0ea"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c10ece37b5ba1b2efa4b6a9fae7507449eaa130b1fdb763b7eec21431bb49b98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1df71d9df50c831beca8036883dc0a4d72feb7baad1c7267b97d305e06f7b9c8"
    sha256 cellar: :any_skip_relocation, ventura:       "7d4ce8998b000a07fe91fcc72044ce67317634d14547c18913b8ac9b98708717"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "828e3b613d37cb86ca511e7a2536084e1bd500afcf01e99d078d43f0cbe3c4c0"
  end

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
