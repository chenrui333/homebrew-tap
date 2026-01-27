class Cozypkg < Formula
  desc "Cozy wrapper around Helm and Flux CD for local development"
  homepage "https://github.com/cozystack/cozypkg"
  url "https://github.com/cozystack/cozypkg/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "2b93668c7c24ebdc0588ca15e7821de77879b883c263f2d295fba41fb9b1c05c"
  license "Apache-2.0"
  head "https://github.com/cozystack/cozypkg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac236ee4f919057930461fe99a988d741dc625d64b9bb5c8834a3fbd93590b0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a89bbe86d30981ba9f41e00f0ee3b1942e88a19185385de28736829de2caa7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d672f019334e6afa54e783697ea3fbcb39688ed50029784f89d63860d3f2a3e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37b64fa374c49a0ac585380b3e90e488847cb3e8f38b45c770492f70aad533d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfa240c1a2204a19d0ed825325c4289f385a23b340babe88e6febd05f6160139"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")

    generate_completions_from_executable(bin/"cozypkg", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cozypkg --version")

    output = shell_output("#{bin}/cozypkg list 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
