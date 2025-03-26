class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.32.1.tar.gz"
  sha256 "7f8b9b1c5f25fc123b57f2c444c32677801c85d80d6bde8a3fe32e02ce935be2"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8894ada6e07fc57cdc7db828f3e5c183900390a0fd7f857409139dfc55f08a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9436ab7e92d616a4516382d1b671fdbd6a3efb13e6a0177ca1bd3e0b6a877d2"
    sha256 cellar: :any_skip_relocation, ventura:       "07982b0de83062e001fe99d0bb6db1f897ec4be03392ae6505f4f404e475b246"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba69b102263e6b538783c0e21186509a12e5a6afe38d0d566df069f01387125f"
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
