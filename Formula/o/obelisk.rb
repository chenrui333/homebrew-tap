class Obelisk < Formula
  desc "Durable and deterministic workflow engine"
  homepage "https://github.com/obeli-sk/obelisk"
  url "https://github.com/obeli-sk/obelisk/archive/refs/tags/v0.38.3.tar.gz"
  sha256 "5194206fe0ae41202c4cd38a31e166ef9978da43fa23ad8dbf29c3e828e9aaff"
  license "AGPL-3.0-only"
  head "https://github.com/obeli-sk/obelisk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6c7d5102ca45a1b4fb9a5e63372b45f391bf38c4a026efd46cc59fc448288b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b0d42206b62a615bd6c4528a65cf28192d1d6a41b5e03c16471f7f188b5062f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "128e4aa535bf237f99fb73dac397cb64ee7f071e4ba0abba962e349591dcb9dd"
    sha256 cellar: :any,                 arm64_linux:   "3cf0f967bc52b2b45851fa27d136c37a4093105b854895217e81de08a0157362"
    sha256 cellar: :any,                 x86_64_linux:  "654d50da27e7135462155de0ff96d4b2d8b14cfa35b6a517d266cf8496f93921"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/obelisk --version")
    output = shell_output("#{bin}/obelisk --not-a-real-option 2>&1", 2)
    assert_match "not-a-real-option", output
  end
end
