# framework: cobra
class Venom < Formula
  desc "Manage and run your integration tests with efficiency"
  homepage "https://github.com/ovh/venom"
  url "https://github.com/ovh/venom/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "8047a7d20aa5be003684182830ddf05b6133f0761a89256b5791fe665358dff9"
  license "Apache-2.0"
  head "https://github.com/ovh/venom.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e8db527425ec5376f5b442cfdea883535aee5a941aea031a404aaa34d52f450"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "831fd809ab5f8b0ee736463089ce8af3b9bf17211963649d7922f947559b0997"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e6b93a2c858af520853f11a9e922b5ec2d828272cda1514401706a9477ef68b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51c28ec00409ba8e8b07b86f8841ba468ac721cec5817c38f9a3f2a899734aec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ce6cc8097b008307085a6ec95dbc1eea22263f10d3eb41155bb4ab0d12d1a5c"
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
