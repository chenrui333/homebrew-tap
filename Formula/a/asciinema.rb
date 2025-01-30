class Asciinema < Formula
  desc "Terminal session recorder"
  homepage "https://asciinema.org/"
  url "https://github.com/asciinema/asciinema/archive/refs/tags/v3.0.0-rc.3.tar.gz"
  sha256 "3e7402589eac1a704951e3c48d769f5d007c52630f17ec895dfad6676e4ba6b9"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2617be3b02bb19fb32c00684c63924c79391b86f0a37cddf46fbf3b825fe903f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "811e2a6b8a655b4fa8dff9d36f7ca300f07d9e6b5b40d21e9ad45a2ed8325032"
    sha256 cellar: :any_skip_relocation, ventura:       "b36dfbe26d0012a44b2c3e232ea710030ac68bf6681a965ae4ed0ced19f456c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48722435f1d71ca839c07d01183d850fa1bf1667fe9e06b665a2f7455d07b38d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/asciinema --version")

    output = shell_output("#{bin}/asciinema cat non_existing_file 2>&1", 1)
    assert_match "No such file or directory", output
  end
end
