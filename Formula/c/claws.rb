class Claws < Formula
  desc "Terminal UI for AWS resource management"
  homepage "https://github.com/clawscli/claws"
  url "https://github.com/clawscli/claws/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "ef2d006e709f315fa09ed53a407fba6887918c1672f615d6b8fd059fd6600acd"
  license "Apache-2.0"
  head "https://github.com/clawscli/claws.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06d392137b5a29ba1a5bce110e229fa8c1c106d92d1326ffaa2f0b47f4d84109"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06d392137b5a29ba1a5bce110e229fa8c1c106d92d1326ffaa2f0b47f4d84109"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06d392137b5a29ba1a5bce110e229fa8c1c106d92d1326ffaa2f0b47f4d84109"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79b64bfb06e44cb1e575b3b8d89246aedbfd4a88cae63adb65928d18e46e4d9a"
    sha256 cellar: :any,                 x86_64_linux:  "572c6aab58cbd902fad7dade4181baa86f67cccaa11695dcf2947b1d65d748b6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"claws"), "./cmd/claws"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claws --version")

    output = shell_output("#{bin}/claws --profile invalid/name 2>&1", 1)
    assert_match "Error: invalid profile name: invalid/name", output
    assert_match "Valid characters: alphanumeric, hyphen, underscore, period", output
  end
end
