class GhRepoMan < Formula
  desc "Manage GitHub repositories interactively from the terminal"
  homepage "https://github.com/2KAbhishek/gh-repo-man"
  url "https://github.com/2KAbhishek/gh-repo-man/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "9dc00f463a52346ea95e493e34555094b295487712a0035947ad221db788d1e9"
  license "MIT"
  head "https://github.com/2KAbhishek/gh-repo-man.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72fa068b50ea2b6755f345d817018724e189c2672c6ac6840767a2e2e36a2185"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72fa068b50ea2b6755f345d817018724e189c2672c6ac6840767a2e2e36a2185"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8121d6aa166b2cb0c6a01c1ecd1a89914e11cf3c8d70e1ff849123af22239d8e"
    sha256 cellar: :any,                 x86_64_linux:  "c7ba9064ba66a51bbee7864238ab907fa9eb055e64ca586991b6a67a591e138d"
  end

  depends_on "go" => :build
  depends_on "fzf"
  depends_on "gh"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."
  end

  test do
    testbin = testpath/"test-bin"
    testbin.mkpath

    gh = testbin/"gh"
    gh.write <<~SH
      #!/bin/sh
      if [ "$1" = "repo" ] && [ "$2" = "list" ]; then
        cat <<'JSON'
      [{"name":"sample-repo","description":"Sample repository","url":"https://github.com/brewtest/sample-repo","stargazerCount":3,"forkCount":1,"watchers":{"totalCount":2},"issues":{"totalCount":0},"owner":{"login":"brewtest"},"createdAt":"2025-01-01T00:00:00Z","updatedAt":"2025-01-02T00:00:00Z","diskUsage":42,"homepageUrl":"","isFork":false,"isArchived":false,"isPrivate":false,"isTemplate":false,"repositoryTopics":[],"primaryLanguage":{"name":"Go"}}]
      JSON
        exit 0
      fi
      if [ "$1" = "api" ] && [ "$2" = "user" ]; then
        echo '{"login":"brewtest"}'
        exit 0
      fi
      echo "unexpected gh invocation: $*" >&2
      exit 1
    SH

    fzf = testbin/"fzf"
    fzf.write <<~SH
      #!/bin/sh
      IFS= read -r first_line
      printf '%s\n' "$first_line"
    SH

    git = testbin/"git"
    git.write <<~SH
      #!/bin/sh
      if [ "$1" = "clone" ]; then
        mkdir -p "$3/.git"
        exit 0
      fi
      echo "unexpected git invocation: $*" >&2
      exit 1
    SH

    chmod 0755, [gh, fzf, git]
    ENV.prepend_path "PATH", testbin

    home = Pathname(Dir.home)
    config_dir = home/".config"/"gh-repo-man"
    config_dir.mkpath
    config = config_dir/"config.yml"
    config.write <<~YAML
      repos:
        projects_dir: #{home/"projects"}
        per_user_dir: false
      integrations:
        post_clone:
          enabled: false
    YAML

    output = shell_output("#{bin}/gh-repo-man --user brewtest")
    assert_match "Successfully cloned sample-repo", output
    assert_path_exists home/"projects"/"sample-repo"/".git"
  end
end
