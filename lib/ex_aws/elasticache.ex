defmodule ExAws.ElastiCache do
  @moduledoc """
  Operations for ElastiCache

  Documentation: http://docs.aws.amazon.com/AmazonElastiCache/latest/APIReference/Welcome.html

  ## Basic Usage
  ```elixir
  alias ExAws.ElastiCache

  ElastiCache.create_cache_cluster("MyMemcachedCluster", "cache.t3.medium", "memcached", 1,
    [preferred_availability_zones: ["us-east-1a"]]
  ) |> ExAws.request

  ElastiCache.describe_cache_clusters(
    [cache_cluster_id: "MyMemcachedCluster", show_cache_node_info: true]
  ) |> ExAws.request
  ```
  """

  use ExAws.Utils,
  format_type: :xml,
  non_standard_keys: %{
    az_mode: "AZMode"
  }

  @version "2015-02-02"

  @type tag :: {key :: atom, value :: binary}
  @type node_group_configuration ::
    {
      primary_availability_zone :: binary,
      replica_availability_zones :: [binary, ...],
      replica_count :: integer,
      slots :: binary
    }

  @doc """
  Authorize network ingress to a cache security group.

  Doc: http://docs.aws.amazon.com/AmazonElastiCache/latest/APIReference/API_AuthorizeCacheSecurityGroupIngress.html

  ## Examples:

        iex> ExAws.ElastiCache.authorize_cache_security_group_ingress("MyCacheSecurityGroup", "MyEC2SecurityGroup", "MyEC2SecurityGroupOwner")
        %ExAws.Operation.Query{action: :authorize_cache_security_group_ingress,
        params: %{
          "Action" => "AuthorizeCacheSecurityGroupIngress",
          "CacheSecurityGroupName" => "MyCacheSecurityGroup",
          "EC2SecurityGroupName" => "MyEC2SecurityGroup",
          "EC2SecurityGroupOwnerId" => "MyEC2SecurityGroupOwner",
          "Version" => "2015-02-02"
        },
        path: "/",
        service: :elasticache}
  """
  @spec authorize_cache_security_group_ingress(cache_security_group_name :: binary, ec2_security_group_name :: binary, ec2_security_group_owner_id :: binary) :: ExAws.Operation.Query.t
  def authorize_cache_security_group_ingress(cache_security_group_name, ec2_security_group_name, ec2_security_group_owner_id) do
    [ {"CacheSecurityGroupName", cache_security_group_name},
      {"EC2SecurityGroupName", ec2_security_group_name},
      {"EC2SecurityGroupOwnerId", ec2_security_group_owner_id} ]
      |> build_request(:authorize_cache_security_group_ingress)
  end


  @doc """
  Makes a copy of an existing snapshot.

  Doc: http://docs.aws.amazon.com/AmazonElastiCache/latest/APIReference/API_CopySnapshot.html

  ## Examples:

        iex> ExAws.ElastiCache.copy_snapshot("SourceSnapshot", "TargetSnapshot")
        %ExAws.Operation.Query{action: :copy_snapshot,
        params: %{
          "Action" => "CopySnapshot",
          "SourceSnapshotName" => "SourceSnapshot",
          "TargetSnapshotName" => "TargetSnapshot",
          "Version" => "2015-02-02"
        },
        path: "/",
        service: :elasticache}
  """
  @spec copy_snapshot(source_snapshot_name :: binary, target_snapshot_name :: binary) :: ExAws.Operation.Query.t
  def copy_snapshot(source_snapshot_name, target_snapshot_name) do
    [ {"SourceSnapshotName", source_snapshot_name},
      {"TargetSnapshotName", target_snapshot_name}]
      |> build_request(:copy_snapshot)
  end


  @doc """
  Creates a cache cluster. All nodes in the cache cluster run the same protocol-
  compliant cache engine software, either Memcached or Redis.

  Doc: http://docs.aws.amazon.com/AmazonElastiCache/latest/APIReference/API_CreateCacheCluster.html

  ## Examples:

        iex> ExAws.ElastiCache.create_cache_cluster("MyMemcachedCluster", "cache.m3.medium", "memcached", 1, [preferred_availability_zones: ["us-east-1a"]])
        %ExAws.Operation.Query{action: :create_cache_cluster,
        params: %{
          "Action" => "CreateCacheCluster",
          "CacheClusterId" => "MyMemcachedCluster",
          "CacheNodeType" => "cache.m3.medium",
          "Engine" => "memcached",
          "NumCacheNodes" => 1,
          "PreferredAvailabilityZones.PreferredAvailabilityZone.1" => "us-east-1a",
          "Version" => "2015-02-02"},
        path: "/",
        service: :elasticache}

        iex> ExAws.ElastiCache.create_cache_cluster("MyMemcachedCluster", "cache.m3.medium", "memcached", 1)
        %ExAws.Operation.Query{action: :create_cache_cluster,
        params: %{
          "Action" => "CreateCacheCluster",
          "CacheClusterId" => "MyMemcachedCluster",
          "CacheNodeType" => "cache.m3.medium",
          "Engine" => "memcached",
          "NumCacheNodes" => 1,
          "Version" => "2015-02-02"},
        path: "/",
        service: :elasticache}

  """
  @type create_cache_cluster :: [
    auth_token: binary,
    auto_minor_version_upgrade: boolean,
    az_mode: binary,
    cache_parameter_group_name: binary,
    cache_security_group_names: [binary, ...],
    cache_subnet_group_name: binary,
    engine_version: binary,
    notification_topic_arn: binary,
    port: integer,
    preferred_availability_zone: binary,
    preferred_availability_zones: [binary, ...],
    preferred_maintenance_window: binary,
    replication_group_id: binary,
    security_group_ids: [binary, ...],
    snapshot_arns: [binary, ...],
    snapshot_name: binary,
    snapshot_retention_limit: integer,
    snapshot_window: binary,
    tags: [tag, ...]
  ]
  @spec create_cache_cluster(cache_cluster_id :: binary, cache_node_type :: binary, engine :: binary, num_cache_nodes :: integer, opts :: create_cache_cluster) :: ExAws.Operation.Query.t
  def create_cache_cluster(cache_cluster_id, cache_node_type, engine, num_cache_nodes, opts \\ []) do
    [ {"CacheClusterId", cache_cluster_id},
      {"CacheNodeType", cache_node_type},
      {"Engine", engine},
      {"NumCacheNodes", num_cache_nodes} |
      opts ]
    |> build_request(:create_cache_cluster)
  end

  @doc """
  Creates a Redis replication group.

  Doc: http://docs.aws.amazon.com/AmazonElastiCache/latest/APIReference/API_CreateReplicationGroup.html

  ## Examples:

        iex> ExAws.ElastiCache.create_replication_group("myRepGroup", "My Rep Group")
        %ExAws.Operation.Query{action: :create_replication_group,
        params: %{
          "Action" => "CreateReplicationGroup",
          "ReplicationGroupId" => "myRepGroup",
          "ReplicationGroupDescription" => "My Rep Group",
          "Version" => "2015-02-02"},
        path: "/",
        service: :elasticache}

        iex> ExAws.ElastiCache.create_replication_group("myRepGroup", "My Rep Group", [node_group_configurations: [{"us-east-1a", ["us-east-1b", "us-east-1c"], 2, 0}, {"us-east-1b", ["us-east-1a", "us-east-1c"], 2, 2}]])
        %ExAws.Operation.Query{action: :create_replication_group,
        params: %{
          "Action" => "CreateReplicationGroup",
          "ReplicationGroupId" => "myRepGroup",
          "ReplicationGroupDescription" => "My Rep Group",
          "NodeGroupConfigurations.NodeGroupConfiguration.1.PrimaryAvailabilityZone" => "us-east-1a",
          "NodeGroupConfigurations.NodeGroupConfiguration.1.ReplicaAvailabilityZones.AvailabilityZone.1" => "us-east-1b",
          "NodeGroupConfigurations.NodeGroupConfiguration.1.ReplicaAvailabilityZones.AvailabilityZone.2" => "us-east-1c",
          "NodeGroupConfigurations.NodeGroupConfiguration.1.ReplicaCount" => 2,
          "NodeGroupConfigurations.NodeGroupConfiguration.1.Slots" => 0,
          "NodeGroupConfigurations.NodeGroupConfiguration.2.PrimaryAvailabilityZone" => "us-east-1b",
          "NodeGroupConfigurations.NodeGroupConfiguration.2.ReplicaAvailabilityZones.AvailabilityZone.1" => "us-east-1a",
          "NodeGroupConfigurations.NodeGroupConfiguration.2.ReplicaAvailabilityZones.AvailabilityZone.2" => "us-east-1c",
          "NodeGroupConfigurations.NodeGroupConfiguration.2.ReplicaCount" => 2,
          "NodeGroupConfigurations.NodeGroupConfiguration.2.Slots" => 2,
          "Version" => "2015-02-02"
        },
        path: "/",
        service: :elasticache}
  """
  @type create_replication_group :: [
    at_rest_encryption_enabled: boolean,
    auth_token: binary,
    automatic_failover_enabled: boolean,
    auto_minor_version_upgrade: boolean,
    cache_node_type: binary,
    cache_parameter_group_name: binary,
    cache_security_group_names: [binary, ...],
    cache_subnet_group_names: binary,
    engine: binary,
    engine_version: binary,
    node_group_configurations: [node_group_configuration, ...],
    notification_topic_arn: binary,
    num_cache_clusters: integer,
    num_node_groups: integer,
    port: integer,
    preferred_cache_clusters_azs: [binary, ...],
    preferred_maintenance_window: binary,
    primary_cluster_id: binary,
    replicas_per_node_group: binary,
    security_group_ids: [binary, ...],
    snapshot_arns: [binary, ...],
    snapshot_name: binary,
    snapshot_retention_limit: integer,
    snapshot_window: binary,
    tags: [tag, ...],
    transit_encryption_enabled: boolean
  ]
  @spec create_replication_group(replication_group_id :: binary, replication_group_description :: binary, opts :: create_replication_group) :: ExAws.Operation.Query.t
  def create_replication_group(replication_group_id, replication_group_description, opts \\ []) do
    [ {"ReplicationGroupId", replication_group_id},
      {"ReplicationGroupDescription", replication_group_description} |
      opts ]
    |> build_request(:create_replication_group)
  end

  @doc """
  Creates a copy of an entire cluster or replication group at a specific moment in time.

  Doc: http://docs.aws.amazon.com/AmazonElastiCache/latest/APIReference/API_CreateSnapshot.html

  ## Examples:

        iex> ExAws.ElastiCache.create_snapshot("MySnapshot")
        %ExAws.Operation.Query{action: :create_snapshot,
        params: %{
          "Action" => "CreateSnapshot",
          "SnapshotName" => "MySnapshot",
          "Version" => "2015-02-02"
        },
        path: "/",
        service: :elasticache}

        iex> ExAws.ElastiCache.create_snapshot("MySnapshot", [cache_cluster_id: "MyCacheClusterId"])
        %ExAws.Operation.Query{action: :create_snapshot,
        params: %{
          "Action" => "CreateSnapshot",
          "SnapshotName" => "MySnapshot",
          "CacheClusterId" => "MyCacheClusterId",
          "Version" => "2015-02-02"
        },
        path: "/",
        service: :elasticache}
  """
  @type create_snapshot :: [
    cache_cluster_id: binary,
    replication_group_id: binary
  ]
  @spec create_snapshot(snapshot_name :: binary, opts :: create_snapshot) :: ExAws.Operation.Query.t
  def create_snapshot(snapshot_name, opts \\ []) do
    [ {"SnapshotName", snapshot_name} | opts ] |> build_request(:create_snapshot)
  end

  @doc """
  Deletes a previously provisioned cache cluster. DeleteCacheCluster deletes
  all associated cache nodes, node endpoints and the cache cluster itself.
  When you receive a successful response from this operation, Amazon
  ElastiCache immediately begins deleting the cache cluster; you cannot
  cancel or revert this operation.

  Doc: http://docs.aws.amazon.com/AmazonElastiCache/latest/APIReference/API_DeleteCacheCluster.html

  ## Examples:

        iex> ExAws.ElastiCache.delete_cache_cluster("Test")
        %ExAws.Operation.Query{action: :delete_cache_cluster,
        params: %{
          "Action" => "DeleteCacheCluster",
          "CacheClusterId" => "Test",
          "Version" => "2015-02-02"
        },
        path: "/",
        service: :elasticache}

        iex> ExAws.ElastiCache.delete_cache_cluster("Test", [final_snapshot_identifier: "finalSnapshot"])
        %ExAws.Operation.Query{action: :delete_cache_cluster,
        params: %{
          "Action" => "DeleteCacheCluster",
          "CacheClusterId" => "Test",
          "FinalSnapshotIdentifier" => "finalSnapshot",
          "Version" => "2015-02-02"
        },
        path: "/",
        service: :elasticache}
  """
  @type delete_cache_cluster :: [
    final_snapshot_identifier: binary
  ]
  @spec delete_cache_cluster(cache_cluster_id :: binary, opts :: delete_cache_cluster) :: ExAws.Operation.Query.t
  def delete_cache_cluster(cache_cluster_id, opts \\ []) do
    [ {"CacheClusterId", cache_cluster_id} | opts ]
    |> build_request(:delete_cache_cluster)
  end

  @doc """
  Deletes an existing replication group.

  Doc: http://docs.aws.amazon.com/AmazonElastiCache/latest/APIReference/API_DeleteReplicationGroup.html

  ## Examples:

        iex> ExAws.ElastiCache.delete_replication_group("MyRepGroup")
        %ExAws.Operation.Query{action: :delete_replication_group,
        params: %{
          "Action" => "DeleteReplicationGroup",
          "ReplicationGroupId" => "MyRepGroup",
          "Version" => "2015-02-02"
        },
        path: "/",
        service: :elasticache}

        iex> ExAws.ElastiCache.delete_replication_group("MyRepGroup", [retain_primary_cluster: false])
        %ExAws.Operation.Query{action: :delete_replication_group,
        params: %{
          "Action" => "DeleteReplicationGroup",
          "ReplicationGroupId" => "MyRepGroup",
          "RetainPrimaryCluster" => false,
          "Version" => "2015-02-02"
        },
        path: "/",
        service: :elasticache}
  """
  @type delete_replication_group :: [
    final_snapshot_identifier: binary,
    retain_primary_cluster: boolean
  ]
  @spec delete_replication_group(replication_group_id :: binary) :: ExAws.Operation.Query.t
  def delete_replication_group(replication_group_id, opts \\ []) do
    [ {"ReplicationGroupId", replication_group_id} | opts ]
    |> build_request(:delete_replication_group)
  end


  @doc """
  Deletes an existing snapshot

  Doc: http://docs.aws.amazon.com/AmazonElastiCache/latest/APIReference/API_DeleteSnapshot.html

  ## Examples:

        iex> ExAws.ElastiCache.delete_snapshot("MySnapshotName")
        %ExAws.Operation.Query{action: :delete_snapshot,
        params: %{
          "Action" => "DeleteSnapshot",
          "SnapshotName" => "MySnapshotName",
          "Version" => "2015-02-02"
        },
        path: "/",
        service: :elasticache}
  """
  @spec delete_snapshot(snapshot_name :: binary) :: ExAws.Operation.Query.t
  def delete_snapshot(snapshot_name) do
    [{"SnapshotName", snapshot_name}] |> build_request(:delete_snapshot)
  end


  @doc """
  Returns information about all provisioned cache clusters if no cache cluster
  identifier is specified, or about a specific cache cluster if a
  cache cluster identifier is supplied.

  Doc: http://docs.aws.amazon.com/AmazonElastiCache/latest/APIReference/API_DescribeCacheClusters.html

  ## Examples:

      iex> ExAws.ElastiCache.describe_cache_clusters
      %ExAws.Operation.Query{action: :describe_cache_clusters,
      params: %{
        "Action" => "DescribeCacheClusters",
        "Version" => "2015-02-02"
      },
      path: "/",
      service: :elasticache}

      iex> ExAws.ElastiCache.describe_cache_clusters([max_records: 100, show_cache_node_info: false])
      %ExAws.Operation.Query{action: :describe_cache_clusters,
      params: %{
        "Action" => "DescribeCacheClusters",
        "MaxRecords" => 100,
        "ShowCacheNodeInfo" => false,
        "Version" => "2015-02-02"
      },
      path: "/",
      service: :elasticache}
  """
  @type describe_cache_clusters :: [
    cache_cluster_id: binary,
    marker: binary,
    max_records: integer,
    show_cache_clusters_not_in_replication_groups: boolean,
    show_cache_node_info: boolean
  ]
  @spec describe_cache_clusters(opts :: describe_cache_clusters) :: ExAws.Operation.Query.t
  def describe_cache_clusters(opts \\ []) do
    opts |> build_request(:describe_cache_clusters)
  end


  @doc """
  Returns a list of the available cache engines and their versions.

  Doc: http://docs.aws.amazon.com/AmazonElastiCache/latest/APIReference/API_DescribeCacheEngineVersions.html

  ## Examples:

        iex> ExAws.ElastiCache.describe_cache_engine_versions
        %ExAws.Operation.Query{action: :describe_cache_engine_versions,
        params: %{
          "Action" => "DescribeCacheEngineVersions",
          "Version" => "2015-02-02"
        },
        path: "/",
        service: :elasticache}

        iex> ExAws.ElastiCache.describe_cache_engine_versions([cache_parameter_group_family: "memcached1.4", default_only: true, marker: 100])
        %ExAws.Operation.Query{action: :describe_cache_engine_versions,
        params: %{
          "Action" => "DescribeCacheEngineVersions",
          "CacheParameterGroupFamily" => "memcached1.4",
          "DefaultOnly" => true,
          "Marker" => 100,
          "Version" => "2015-02-02"
        },
        path: "/",
        service: :elasticache}
  """
  @type describe_cache_engine_versions :: [
    cache_parameter_group_family: binary,
    default_only: boolean,
    engine: binary,
    engine_version: binary,
    marker: binary,
    max_records: integer
  ]
  @spec describe_cache_engine_versions(opts :: describe_cache_engine_versions) :: ExAws.Operation.Query.t
  def describe_cache_engine_versions(opts \\ []) do
    opts |> build_request(:describe_cache_engine_versions)
  end


  @doc """
  Returns information about a particular replication group. If no identifier is specified,
  DescribeReplicationGroups returns information about all replication groups.

  Doc: https://docs.aws.amazon.com/AmazonElastiCache/latest/APIReference/API_DescribeReplicationGroups.html

  ## Examples:

      iex> ExAws.ElastiCache.describe_replication_groups
      %ExAws.Operation.Query{action: :describe_replication_groups,
      params: %{
        "Action" => "DescribeReplicationGroups",
        "Version" => "2015-02-02"
      },
      path: "/",
      service: :elasticache}

      iex> ExAws.ElastiCache.describe_replication_groups([max_records: 100, replication_group_id: "my-replication-group"])
      %ExAws.Operation.Query{action: :describe_replication_groups,
      params: %{
        "Action" => "DescribeReplicationGroups",
        "MaxRecords" => 100,
        "ReplicationGroupId" => "my-replication-group",
        "Version" => "2015-02-02"
      },
      path: "/",
      service: :elasticache}
  """
  @type describe_replication_groups :: [
    marker: binary,
    max_records: integer,
    replication_group_id: binary
  ]
  @spec describe_replication_groups(opts :: describe_replication_groups) :: ExAws.Operation.Query.t
  def describe_replication_groups(opts \\ []) do
    opts |> build_request(:describe_replication_groups)
  end


  @doc """
  Reboots some, or all, of the cache nodes in the provisioned cluster. This operation applies
  any modified cache parameter groups to the cluster.

  Doc: http://docs.aws.amazon.com/AmazonElastiCache/latest/APIReference/API_RebootCacheCluster.html

  ## Examples:

      iex> ExAws.ElastiCache.reboot_cache_cluster("MyCacheClusterId", ["0001", "0002", "0003"])
      %ExAws.Operation.Query{action: :reboot_cache_cluster,
      params: %{
        "Action" => "RebootCacheCluster",
        "CacheClusterId" => "MyCacheClusterId",
        "CacheNodeIdsToReboot.CacheNodeId.1" => "0001",
        "CacheNodeIdsToReboot.CacheNodeId.2" => "0002",
        "CacheNodeIdsToReboot.CacheNodeId.3" => "0003",
        "Version" => "2015-02-02"
      },
      path: "/",
      service: :elasticache}
  """
  @spec reboot_cache_cluster(cache_cluster_id :: binary, cache_node_ids_to_reboot :: nonempty_list(binary)) :: ExAws.Operation.Query.t
  def reboot_cache_cluster(cache_cluster_id, cache_node_ids_to_reboot) do
    opts = [
      cache_cluster_id: cache_cluster_id,
      cache_node_ids_to_reboot: cache_node_ids_to_reboot
    ]
    opts |> build_request(:reboot_cache_cluster)
  end
  ####################
  # Helper Functions #
  ####################

  defp build_request(opts, action) do
    opts
    |> Enum.flat_map(&format_param/1)
    |> request(action)
  end

  defp request(params, action) do
    action_string =
      action
      |> Atom.to_string
      |> Macro.camelize

    %ExAws.Operation.Query{
      path: "/",
      params: params |> filter_nil_params |> Map.put("Action", action_string) |> Map.put("Version", @version),
      service: :elasticache,
      action: action
    }
  end

  defp format_param({:cache_node_ids_to_reboot, cache_node_ids_to_reboot}) do
    cache_node_ids_to_reboot |> format(prefix: "CacheNodeIdsToReboot.CacheNodeId")
  end

  defp format_param({:cache_security_group_names, cache_security_group_names}) do
    cache_security_group_names |> format(prefix: "CacheSecurityGroupNames.CacheSecurityGroupName")
  end

  defp format_param({:node_group_configurations, node_group_configurations}) do
    format_node_group_configuration =
      fn {primary_availability_zone, replica_availability_zones, replica_count, slots} ->
        [ primary_availability_zone: primary_availability_zone,
          replica_availability_zones: [availability_zone: replica_availability_zones],
          replica_count: replica_count,
          slots: slots
        ]
      end

    node_group_configurations
    |> Enum.map(format_node_group_configuration)
    |> format(prefix: "NodeGroupConfigurations.NodeGroupConfiguration")
  end

  defp format_param({:preferred_availability_zones, preferred_availability_zones}) do
    preferred_availability_zones |> format(prefix: "PreferredAvailabilityZones.PreferredAvailabilityZone")
  end

  defp format_param({:preferred_cache_cluster_azs, preferred_cache_cluster_azs}) do
    preferred_cache_cluster_azs |> format(prefix: "PreferredCacheClusterAZs.AvailabilityZone")
  end

  defp format_param({:security_group_ids, security_group_ids}) do
    security_group_ids |> format(prefix: "SecurityGroupIds.SecurityGroupId")
  end

  defp format_param({:snapshot_arns, snapshot_arns}) do
    snapshot_arns |> format(prefix: "SnapshotArns.SnapshotArn")
  end

  defp format_param({:tags, tags}) do
    tags
    |> Enum.map(fn {key, value} -> [key: maybe_stringify(key), value: value] end)
    |> format(prefix: "Tags.Tag")
  end

  defp format_param({key, parameters}) do
    format([{key, parameters}])
  end
end
