class FuckUCode < Formula
  desc "Detect legacy code mess and generate a beautiful report"
  homepage "https://github.com/Done-0/fuck-u-code"
  url "https://github.com/Done-0/fuck-u-code/archive/refs/tags/v1.0.0-beta.1.tar.gz"
  sha256 "0ca19c3d57da39ea091b47e829cea18e5a2420c68468e7c03995a3c9649a40bf"
  license "MIT"
  head "https://github.com/Done-0/fuck-u-code.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09f86572df354eb2204020ae23ec2cb471a98ff78e3f6c1541a58950e7d9241b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09f86572df354eb2204020ae23ec2cb471a98ff78e3f6c1541a58950e7d9241b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09f86572df354eb2204020ae23ec2cb471a98ff78e3f6c1541a58950e7d9241b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae70c4f44fa7bf8f87995c58f50e9dab53a46e594bfc2b361f5758535a718362"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97356e03b51d09f9abc2c58be5562056bb27ad3120ed94909fd57ed4c319a8e6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/fuck-u-code"

    generate_completions_from_executable(bin/"fuck-u-code", shell_parameter_format: :cobra)
  end

  test do
    assert_match "🌸 屎山代码分析报告 🌸", shell_output("#{bin}/fuck-u-code analyze")
  end
end
