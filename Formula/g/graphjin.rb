class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.18.15.tar.gz"
  sha256 "6484266b98f0c60daccf544837dde73b1b0232d24f9e956c8020e2cf579e9a3d"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e2da8f6e07c6a38f74d0c7bb9bea4da14a5aee0c380a3c31d0d2ee57999c950"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b296c22ad3ec5225ffefc59b867f2979b2b202cb941cf615ed3eaeae1c594d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c46060992d0fb2e033e19538e90f633dc4fb1038e4cceea4de30d780fec36f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e690bb0775fb7affc6b42a14256e83689592f91d9dfad425540b3918eb0a18c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f46df21d504a366d2858113dfed4eaebef9fd24ffca01ac31ec09e7ad6bdd98"
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

    system bin/"graphjin", "serve", "new", "myapp"
    assert_path_exists testpath/"myapp"
    assert_match "app_name: \"Myapp Development\"", (testpath/"myapp/dev.yml").read
  end
end
