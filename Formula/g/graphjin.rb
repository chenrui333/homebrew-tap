class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "3f491ba2fe6929e6e60ccc43af85fbae612e415182b84cd37aad9d680a1fe00e"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "499b3cb9ec9b4eaac6a5c25bc2df60a5988eac8747b35f5bcc070d47d565a988"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d7fbba485a81f486ae5ec9c622abf28e46858b61dd57cc77e1a2c08a32b719f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87c956be7766e5a2aaa3d019da2138252d144d47fe40bee4d5bccbce6b7126c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8176531c8cb40b973551b18d5c846762ee59181265718e760a172786f001b675"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eaf58021010e96f2ddb192fc9936715a84ed5f09c3f79c5db49c405cd039227f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
      -X github.com/dosco/graphjin/serv/v3.version=#{version}
    ]

    cd "cmd" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"graphjin", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/graphjin version")

    system bin/"graphjin", "new", "myapp"
    assert_path_exists testpath/"myapp"
    assert_match "app_name: \"Myapp Development\"", (testpath/"myapp/dev.yml").read
  end
end
