class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.18.35.tar.gz"
  sha256 "54a347af072c9ed6a61ed13c7da4fb2eace4f1f96ca1d3f6820d541172e78864"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "682fea600d410a84ecd1d0aa999050ee3394a8d99e32f1d436faed52164b28d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30b7fe946fda5692ce68bd0f37639edbdae4ed806162b24d72fcfb7da23a5f4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a22e2fe8771a86d938b50344afa6dd677b23ea7d9a74d61cd00f8f88c5ab6d6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afb6c026ed81a720363f46cd7613739ee0ea1dc1e593b4f0d3fbba2071b7b1c2"
    sha256 cellar: :any,                 x86_64_linux:  "f659a19b039c7caef6834f60367b21019fda856cd2def61e997d637045f0cafa"
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
