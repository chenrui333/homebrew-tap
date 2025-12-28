class Gignr < Formula
  desc "Effortlessly Manage and Generate .gitignore files"
  homepage "https://github.com/jasonuc/gignr"
  url "https://github.com/jasonuc/gignr/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "f7b4d820de3230c59c999f7a85e6652ad74dfba03f41f90f946b48c0d8f04578"
  license "MIT"
  head "https://github.com/jasonuc/gignr.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4db2a955aec8414dc9f5f227c6594c733248334c3cc1d46a5916adef64fde5fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8be4d6a3a79c0f1deec71f80dc2b1dc4b10e51217130fec52674841cbddd9950"
    sha256 cellar: :any_skip_relocation, ventura:       "c4b464e6f8a3dff4632f7c5ccd94553456f6a64cb664f483c81d2c0a63f10606"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2dcba412a2f8e91b69618146847904e2cdd7e981e37ecae795bee61f171a0cd8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"gignr", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gignr --version")

    # failed due to github api rate limit
    # assert_match "Created .gitignore file", shell_output("#{bin}/gignr create gh:Go tt:clion my-template")
    # assert_match "Binaries for programs and plugins", (testpath/".gitignore").read
  end
end
