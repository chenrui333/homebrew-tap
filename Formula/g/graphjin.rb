class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.18.24.tar.gz"
  sha256 "8e8845acd4a2372e14f740f72bb6a16b4df6826fe1c339b1b023e2dc25a72852"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39270f7011b439d0375340a8b98110bb3b76c8219c45b280f1a76ef95e9a07f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c24db275fb4a67b5b7e9dd388e155bab8005aece44ba749adae848b547ff298a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b5baa71a041bdf052b45a347799a9e55f238f2843319141a433fdd468f559d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08d20f832176754f7935cc9d0977f59171b690d1c87f714d17a48737077ab736"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06050aab9ee8bba50f809347e328242f19e86e742435af979b9e15ff4e67bbed"
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
