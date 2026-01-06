# framework: cobra
class Venom < Formula
  desc "Manage and run your integration tests with efficiency"
  homepage "https://github.com/ovh/venom"
  url "https://github.com/ovh/venom/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "de7ef1f7794d0aa3e3dceb55cc54e44d4a52594bf1e9af0e9c73f85e6071cfd3"
  license "Apache-2.0"
  head "https://github.com/ovh/venom.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "055ea8c74e4da8b83370f20f4633ec5dbc9f65d6feb062b1b0b080fc0e0ade41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f348c0649bcbeacfb014fdc31cadabe05ca6b8a4c94da7385f80dfc572d2c7fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d75442d6440e547499ec4fa15402c95ec892d9ecda470a5ccddb80430f043bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "442d6db7d53c965b5e0161b07fd3949f5b2878473c4c8960bc9a3c2262092060"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "385fead16c046cc90e7da7ce9c76668c2425f818a9487c127fa8c7227218e346"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/ovh/venom.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/venom"

    generate_completions_from_executable(bin/"venom", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/venom version")

    (testpath/"test.yml").write <<~EOS
      name: Simple Test
      testcases:
        - name: Test echo
          steps:
            - script:
                name: Echo Hello
                script: echo "Hello, world!"
                assertions:
                  - result.code ShouldEqual 0
                  - result.systemout ShouldContainSubstring "Hello, world!"
    EOS

    output = shell_output("#{bin}/venom run test.yml").gsub(/\e\[(\d+)m/, "")
    assert_equal <<~EOS, output
      \t  [trac] writing venom.log
       • Simple Test (test.yml)
       \t• Test-echo PASS
      final status: PASS
    EOS
  end
end
