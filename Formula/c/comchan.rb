class Comchan < Formula
  desc "Minimal serial monitor and plotter for embedded applications"
  homepage "https://github.com/Vaishnav-Sabari-Girish/ComChan"
  url "https://github.com/Vaishnav-Sabari-Girish/ComChan/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "35ab030c6d6c0a6ed24f2ec995f2a340cf76bf61f7c3c7af53fe38344fa0072e"
  license "MIT"
  head "https://github.com/Vaishnav-Sabari-Girish/ComChan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0293019d36568f79c50f3b23b69580511980d4381135f5bf3ec0e1104ef39cf0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16d0112e6f40ee312c3f9a42679668b524307881b0bb249bc74777bd9ba93f53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb3da41f3d38a407713b05b3629e7012055513ba92a6a44e8c046fef6055f33e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b513e2c60fc5f192608f2f687104e5f239978ae8fe4e773c723a62fc2b4083a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78972aae2e82693364c56cc0bdf7685aa053c2fb3546f962637b07ed9ab0852d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "systemd" # for libudev
  end

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/comchan --version")

    shell_output("HOME=#{testpath} #{bin}/comchan --generate-config")

    config = if OS.mac?
      testpath/"Library/Application Support/comchan/comchan.toml"
    else
      testpath/".config/comchan/comchan.toml"
    end
    assert_path_exists config
    assert_match 'port = "auto"', config.read
  end
end
