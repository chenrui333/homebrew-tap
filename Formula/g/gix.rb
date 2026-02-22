class Gix < Formula
  desc "Git, but with superpowers"
  homepage "https://github.com/ademajagon/gix"
  url "https://github.com/ademajagon/gix/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "4436cb0f26c608bbf4774210422a66a25b27ea8775260373b6b81a52e97bf94a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba224bd32be256e042ebd52d8803721532b9c844e99e5dd29c13c65aa1411dc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba224bd32be256e042ebd52d8803721532b9c844e99e5dd29c13c65aa1411dc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba224bd32be256e042ebd52d8803721532b9c844e99e5dd29c13c65aa1411dc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0130a9b0b7c8aca00325a86c22a87321087502af1d2988f9c97eb90e2c687ecc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0208ee994d4d8ec33cf1464cbbde8c69a5283860c5c131a10d8f51f503893af4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/ademajagon/gix/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gix", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gix --version")

    (testpath/"test.txt").write("Hello World!")
    system "git", "init"
    system "git", "add", "test.txt"

    output = shell_output("#{bin}/gix commit 2>&1", 1)
    assert_match "config not found - run `gix config set-key`", output
  end
end
