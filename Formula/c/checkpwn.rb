class Checkpwn < Formula
  desc "Check Have I Been Pwned and see if it's time for you to change passwords"
  homepage "https://github.com/brycx/checkpwn"
  url "https://github.com/brycx/checkpwn/archive/refs/tags/0.5.4.tar.gz"
  sha256 "f7802910b93932587b8a73aec3b33db24fd8088615a0be89b7c0945500059aae"
  license "MIT"
  head "https://github.com/brycx/checkpwn.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e561ed33f90144ef5e3924ff0b1d67db160b39351992be1adc2674da2c06a6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1ac035448c27c94e808a8aa3d06859c7c87480582915c419f5165012bf67d12"
    sha256 cellar: :any_skip_relocation, ventura:       "e10810958c78a64eb2e5e311e1fe24242dd7d7dd65556df6addf1ab14a656c8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74d69458fd30f4d2467e78de1c8a00a18db486b510eb7670138eb1c1c6c4ecc1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/checkpwn acc test@example.com 2>&1", 101)
    assert_match "Failed to read or parse the configuration file 'checkpwn.yml'", output
  end
end
