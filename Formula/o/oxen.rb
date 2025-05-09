class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.34.2.tar.gz"
  sha256 "a2f0b4284c3739c7e7a75a28176b8ef5a144fc0fe85d1dbd32c430be98aebe04"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd69ef3214ee309b1e66002b281acdde3d83470443e1872e85c70bd3ad255a84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fcb2eb5bf75634f6b18bbf565705361db52c80cf1266a6240d4924488c27b25e"
    sha256 cellar: :any_skip_relocation, ventura:       "9071b7bfbff0e001fb4f05b68f083fffd34ec9f806831214bed487d5efc12dce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56f7a7482a60b4f954369927f21fc04ff01429e948c10d8d85a72a0682b39fa2"
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
