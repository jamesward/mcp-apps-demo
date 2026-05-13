@param String extAppsJs

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>EC2 Instances</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --aws-squid-ink: #232F3E;
            --aws-orange: #FF9900;
            --aws-blue: #0972d3;
            --aws-blue-hover: #033160;
            --aws-text: #16191f;
            --aws-text-secondary: #414d5c;
            --aws-border: #d5dbdb;
            --aws-border-light: #eaeded;
            --aws-bg: #fafbfc;
            --aws-bg-hover: #f2f8fd;
            --aws-bg-selected: #f1faff;
            --aws-green: #037f0c;
            --aws-green-bg: #e6f4ea;
            --aws-red: #d91515;
            --aws-red-bg: #fdecec;
            --aws-yellow: #b7740e;
            --aws-yellow-bg: #fcf4d6;
            --aws-gray: #687078;
            --aws-gray-bg: #e9ebed;
        }

        body {
            font-family: "Amazon Ember", "Helvetica Neue", Helvetica, Arial, sans-serif;
            font-size: 14px;
            color: var(--aws-text);
            background: var(--aws-bg);
            line-height: 1.4;
            padding: 0;
        }

        .page {
            padding: 16px 20px 40px;
            max-width: 1400px;
            margin: 0 auto;
        }

        .panel {
            background: #fff;
            border: 1px solid var(--aws-border);
            border-radius: 8px;
            box-shadow: 0 1px 1px rgba(0,28,36,.05);
        }

        .panel-header {
            padding: 14px 18px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 1px solid var(--aws-border-light);
            flex-wrap: wrap;
            gap: 10px;
        }
        .panel-title {
            font-size: 18px;
            font-weight: 700;
            color: var(--aws-text);
        }
        .panel-title .count {
            color: var(--aws-text-secondary);
            font-weight: 400;
            margin-left: 4px;
        }

        .actions { display: flex; gap: 8px; flex-wrap: wrap; }

        .dropdown { position: relative; display: inline-block; }
        .menu {
            position: absolute;
            top: calc(100% + 4px);
            left: 0;
            background: #fff;
            border: 1px solid var(--aws-border);
            border-radius: 4px;
            box-shadow: 0 2px 8px rgba(0,28,36,.18);
            min-width: 190px;
            z-index: 20;
            display: none;
            padding: 4px 0;
        }
        .menu.open { display: block; }
        .menu-item {
            display: block;
            width: 100%;
            text-align: left;
            padding: 8px 14px;
            border: none;
            background: none;
            cursor: pointer;
            font-family: inherit;
            font-size: 14px;
            color: var(--aws-text);
        }
        .menu-item:hover:not(:disabled) { background: var(--aws-bg-hover); color: var(--aws-blue); }
        .menu-item:disabled { color: #98a2ac; cursor: not-allowed; }
        .menu-item.danger { color: var(--aws-red); }
        .menu-item.danger:hover:not(:disabled) { background: var(--aws-red-bg); color: var(--aws-red); }
        .menu-sep { height: 1px; background: var(--aws-border-light); margin: 4px 0; }

        .btn {
            font-family: inherit;
            font-size: 14px;
            padding: 4px 16px;
            border-radius: 16px;
            border: 1px solid var(--aws-border);
            background: #fff;
            color: var(--aws-text);
            cursor: pointer;
            line-height: 22px;
            height: 30px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: background-color .1s, border-color .1s;
        }
        .btn:hover:not(:disabled) { background: var(--aws-bg-hover); border-color: var(--aws-blue); }
        .btn:disabled { color: #879596; cursor: not-allowed; opacity: 0.65; }
        .btn.primary {
            background: var(--aws-orange);
            color: #16191f;
            border-color: var(--aws-orange);
            font-weight: 700;
        }
        .btn.primary:hover { background: #ec7211; border-color: #ec7211; }
        .caret { font-size: 10px; opacity: 0.7; }

        .toolbar {
            padding: 12px 18px;
            border-bottom: 1px solid var(--aws-border-light);
            display: flex;
            gap: 10px;
            align-items: center;
        }
        .search-wrap {
            flex: 1;
            position: relative;
            max-width: 640px;
        }
        .search-wrap::before {
            content: "🔍";
            position: absolute;
            left: 10px; top: 50%;
            transform: translateY(-50%);
            font-size: 12px;
            opacity: 0.6;
            pointer-events: none;
        }
        .search {
            width: 100%;
            padding: 6px 28px 6px 30px;
            border: 1px solid var(--aws-border);
            border-radius: 4px;
            font-size: 14px;
            font-family: inherit;
            outline: none;
            transition: border-color .15s, box-shadow .15s;
        }
        .search:focus {
            border-color: var(--aws-blue);
            box-shadow: 0 0 0 2px rgba(9,114,211,.2);
        }
        .search-clear {
            position: absolute;
            right: 8px; top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            cursor: pointer;
            font-size: 14px;
            color: var(--aws-gray);
            padding: 2px 6px;
            border-radius: 3px;
        }
        .search-clear:hover { background: var(--aws-gray-bg); }

        .refresh-btn {
            background: #fff;
            border: 1px solid var(--aws-border);
            border-radius: 4px;
            padding: 5px 10px;
            cursor: pointer;
            font-size: 14px;
            color: var(--aws-text-secondary);
        }
        .refresh-btn:hover { background: var(--aws-bg-hover); color: var(--aws-blue); }

        .table-wrap {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
        }
        th, td {
            text-align: left;
            padding: 8px 12px;
            white-space: nowrap;
            border-bottom: 1px solid var(--aws-border-light);
        }
        th {
            background: #fafbfc;
            color: var(--aws-text-secondary);
            font-weight: 700;
            font-size: 12px;
            text-transform: none;
            position: sticky;
            top: 0;
            user-select: none;
        }
        th.sortable { cursor: pointer; }
        th.sortable:hover { background: var(--aws-bg-hover); color: var(--aws-blue); }
        th .sort-indicator {
            display: inline-block;
            margin-left: 4px;
            font-size: 10px;
            color: var(--aws-blue);
            width: 10px;
        }
        th .sort-indicator.inactive { color: var(--aws-border); }

        tbody tr { transition: background-color .08s; }
        tbody tr:hover { background: var(--aws-bg-hover); }
        tbody tr.selected { background: var(--aws-bg-selected); }
        tbody tr.selected:hover { background: #e5f2ff; }
        tbody td { color: var(--aws-text); }

        .id-cell {
            font-family: "SF Mono", Menlo, Consolas, monospace;
            color: var(--aws-blue);
            font-size: 12px;
        }

        .status {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            font-weight: 600;
            padding: 2px 8px;
            border-radius: 10px;
            font-size: 12px;
        }
        .status .dot {
            width: 6px; height: 6px; border-radius: 50%;
            background: currentColor;
        }
        .status.running { color: var(--aws-green); background: var(--aws-green-bg); }
        .status.stopped { color: var(--aws-red); background: var(--aws-red-bg); }
        .status.pending { color: var(--aws-yellow); background: var(--aws-yellow-bg); }
        .status.terminated { color: var(--aws-gray); background: var(--aws-gray-bg); }
        .status.stopping { color: var(--aws-yellow); background: var(--aws-yellow-bg); }

        .check {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            font-size: 12px;
        }
        .check.passed { color: var(--aws-green); }
        .check.na { color: var(--aws-gray); }
        .check.failed { color: var(--aws-red); }

        .alarm { font-size: 12px; color: var(--aws-gray); }
        .alarm.active { color: var(--aws-red); }

        .checkbox {
            width: 14px; height: 14px; cursor: pointer; accent-color: var(--aws-blue);
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: var(--aws-text-secondary);
        }
        .empty-state h3 {
            font-size: 16px;
            margin-bottom: 6px;
            color: var(--aws-text);
        }

        .footer-meta {
            padding: 8px 18px;
            color: var(--aws-text-secondary);
            font-size: 12px;
            border-top: 1px solid var(--aws-border-light);
        }

        @media (prefers-color-scheme: dark) {
            :root {
                --aws-text: #ffffff;
                --aws-text-secondary: #bfc4c9;
                --aws-border: #414d5c;
                --aws-border-light: #2b3847;
                --aws-bg: #0f1b2a;
                --aws-bg-hover: #19344d;
                --aws-bg-selected: #1b3a59;
                --aws-gray: #a4abb3;
                --aws-gray-bg: #2b3847;
                --aws-green-bg: #113021;
                --aws-red-bg: #3a1112;
                --aws-yellow-bg: #3a2a0c;
            }
            body { background: var(--aws-bg); }
            .panel { background: #16212f; border-color: var(--aws-border); }
            .panel-header { border-bottom-color: var(--aws-border-light); }
            .toolbar { border-bottom-color: var(--aws-border-light); }
            th { background: #18263a; }
            tbody tr:hover { background: var(--aws-bg-hover); }
            .btn { background: #16212f; color: var(--aws-text); border-color: var(--aws-border); }
            .btn:hover:not(:disabled) { background: var(--aws-bg-hover); }
            .search { background: #16212f; color: var(--aws-text); border-color: var(--aws-border); }
            .refresh-btn { background: #16212f; color: var(--aws-text-secondary); border-color: var(--aws-border); }
            .refresh-btn:hover { background: var(--aws-bg-hover); }
            .menu { background: #16212f; border-color: var(--aws-border); }
            .menu-item { color: var(--aws-text); }
            .menu-sep { background: var(--aws-border-light); }
        }
    </style>
</head>
<body>

<div class="page">
    <div class="panel">
        <div class="panel-header">
            <div class="panel-title">
                Instances <span class="count" id="instance-count">(0)</span>
            </div>
            <div class="actions">
                <button class="btn" id="connect-btn" disabled>Connect</button>
                <div class="dropdown" id="state-dropdown">
                    <button class="btn" id="state-btn" disabled aria-haspopup="menu" aria-expanded="false">Instance state <span class="caret">▾</span></button>
                    <div class="menu" id="state-menu" role="menu">
                        <button class="menu-item" data-action="start" role="menuitem">Start instance</button>
                        <button class="menu-item" data-action="stop" role="menuitem">Stop instance</button>
                        <button class="menu-item" data-action="reboot" role="menuitem">Reboot instance</button>
                        <div class="menu-sep"></div>
                        <button class="menu-item danger" data-action="terminate" role="menuitem">Terminate instance</button>
                    </div>
                </div>
                <button class="btn" id="actions-btn" disabled>Actions <span class="caret">▾</span></button>
                <button class="btn primary" id="launch-btn">Launch instances <span class="caret">▾</span></button>
            </div>
        </div>

        <div class="toolbar">
            <div class="search-wrap">
                <input class="search" id="search-input" type="text"
                       placeholder="Find instance by attribute or tag (case-sensitive)" autocomplete="off"/>
                <button class="search-clear" id="search-clear" style="display:none" title="Clear">✕</button>
            </div>
            <button class="refresh-btn" id="refresh-btn" title="Refresh">⟳</button>
        </div>

        <div class="table-wrap">
            <table id="instances-table">
                <thead>
                <tr id="head-row">
                    <th style="width:26px"><input type="checkbox" class="checkbox" id="select-all"/></th>
                    <th class="sortable" data-key="name">Name <span class="sort-indicator inactive">↕</span></th>
                    <th class="sortable" data-key="id">Instance ID <span class="sort-indicator inactive">↕</span></th>
                    <th class="sortable" data-key="state">Instance state <span class="sort-indicator inactive">↕</span></th>
                    <th class="sortable" data-key="type">Instance type <span class="sort-indicator inactive">↕</span></th>
                    <th class="sortable" data-key="statusCheck">Status check <span class="sort-indicator inactive">↕</span></th>
                    <th class="sortable" data-key="alarm">Alarm status <span class="sort-indicator inactive">↕</span></th>
                    <th class="sortable" data-key="az">Availability Zone <span class="sort-indicator inactive">↕</span></th>
                    <th class="sortable" data-key="publicIp">Public IPv4 <span class="sort-indicator inactive">↕</span></th>
                    <th class="sortable" data-key="privateIp">Private IPv4 <span class="sort-indicator inactive">↕</span></th>
                    <th class="sortable" data-key="vpc">VPC ID <span class="sort-indicator inactive">↕</span></th>
                    <th class="sortable" data-key="launchTime">Launch time <span class="sort-indicator inactive">↕</span></th>
                </tr>
                </thead>
                <tbody id="instances-body"></tbody>
            </table>
            <div class="empty-state" id="empty-state" style="display:none">
                <h3>No matching instances</h3>
                <div>Try a different search term.</div>
            </div>
        </div>

        <div class="footer-meta" id="footer-meta">Showing 0 of 0 instances</div>
    </div>
</div>

<script id="ext-apps-src" type="text/plain">
$unsafe{extAppsJs}
</script>

@raw
<script type="module">
    const src = document.getElementById('ext-apps-src').textContent;
    const blob = new Blob([src], { type: 'application/javascript' });
    const url = URL.createObjectURL(blob);
    const { App } = await import(url);
    URL.revokeObjectURL(url);

    const app = new App({ name: "list-ec2-instances", version: "1.0.0" });
    await app.connect();

    // Mock EC2 instance fleet
    const INSTANCES = [
        { name: "web-prod-01", id: "i-0a1b2c3d4e5f60011", state: "running", type: "t3.medium",
          statusCheck: "2/2 checks passed", alarm: "No alarms", az: "us-east-1a",
          publicIp: "54.162.77.21", privateIp: "10.0.1.14", vpc: "vpc-0fa112233",
          launchTime: "2026-01-14T09:21:00Z" },
        { name: "web-prod-02", id: "i-0a1b2c3d4e5f60012", state: "running", type: "t3.medium",
          statusCheck: "2/2 checks passed", alarm: "No alarms", az: "us-east-1b",
          publicIp: "54.162.77.22", privateIp: "10.0.1.15", vpc: "vpc-0fa112233",
          launchTime: "2026-01-14T09:22:10Z" },
        { name: "api-prod-01", id: "i-0b1c2d3e4f506aa31", state: "running", type: "m5.large",
          statusCheck: "2/2 checks passed", alarm: "No alarms", az: "us-east-1a",
          publicIp: "3.214.88.101", privateIp: "10.0.2.41", vpc: "vpc-0fa112233",
          launchTime: "2025-11-02T12:03:45Z" },
        { name: "api-prod-02", id: "i-0b1c2d3e4f506aa32", state: "running", type: "m5.large",
          statusCheck: "1/2 checks passed", alarm: "1 alarm", az: "us-east-1c",
          publicIp: "3.214.88.102", privateIp: "10.0.2.42", vpc: "vpc-0fa112233",
          launchTime: "2025-11-02T12:05:11Z" },
        { name: "db-primary", id: "i-0c2d3e4f506aabbcc", state: "running", type: "r6i.xlarge",
          statusCheck: "2/2 checks passed", alarm: "No alarms", az: "us-east-1a",
          publicIp: "-", privateIp: "10.0.3.10", vpc: "vpc-0fa112233",
          launchTime: "2025-08-18T04:00:00Z" },
        { name: "db-replica-01", id: "i-0c2d3e4f506aabbcd", state: "running", type: "r6i.xlarge",
          statusCheck: "2/2 checks passed", alarm: "No alarms", az: "us-east-1b",
          publicIp: "-", privateIp: "10.0.3.11", vpc: "vpc-0fa112233",
          launchTime: "2025-08-18T04:05:00Z" },
        { name: "cache-redis", id: "i-0d3e4f506aabbccdd", state: "running", type: "r6i.large",
          statusCheck: "2/2 checks passed", alarm: "No alarms", az: "us-east-1a",
          publicIp: "-", privateIp: "10.0.4.22", vpc: "vpc-0fa112233",
          launchTime: "2025-09-30T17:14:00Z" },
        { name: "worker-etl-01", id: "i-0e4f506aabbccddee", state: "stopped", type: "c5.2xlarge",
          statusCheck: "-", alarm: "No alarms", az: "us-east-1b",
          publicIp: "-", privateIp: "10.0.5.33", vpc: "vpc-0fa112233",
          launchTime: "2025-07-11T22:40:12Z" },
        { name: "worker-etl-02", id: "i-0e4f506aabbccddef", state: "stopped", type: "c5.2xlarge",
          statusCheck: "-", alarm: "No alarms", az: "us-east-1c",
          publicIp: "-", privateIp: "10.0.5.34", vpc: "vpc-0fa112233",
          launchTime: "2025-07-11T22:41:05Z" },
        { name: "bastion-host", id: "i-0f506aabbccddeeff", state: "running", type: "t3.micro",
          statusCheck: "2/2 checks passed", alarm: "No alarms", az: "us-east-1a",
          publicIp: "52.3.200.18", privateIp: "10.0.0.9", vpc: "vpc-0fa112233",
          launchTime: "2024-12-01T06:00:00Z" },
        { name: "ci-runner-01", id: "i-1a2b3c4d5e6f70081", state: "pending", type: "t3.large",
          statusCheck: "Initializing", alarm: "No alarms", az: "us-east-1b",
          publicIp: "18.204.55.9", privateIp: "10.0.6.77", vpc: "vpc-0fa112233",
          launchTime: "2026-05-13T18:59:44Z" },
        { name: "ml-gpu-train", id: "i-2b3c4d5e6f7008192", state: "running", type: "g5.2xlarge",
          statusCheck: "2/2 checks passed", alarm: "No alarms", az: "us-west-2a",
          publicIp: "34.219.10.44", privateIp: "10.1.0.4", vpc: "vpc-0ab998877",
          launchTime: "2026-04-22T13:30:00Z" },
        { name: "staging-web", id: "i-3c4d5e6f700819a23", state: "stopping", type: "t3.small",
          statusCheck: "-", alarm: "No alarms", az: "us-east-1a",
          publicIp: "54.162.77.99", privateIp: "10.2.1.50", vpc: "vpc-0ee334455",
          launchTime: "2026-03-15T08:18:00Z" },
        { name: "legacy-app", id: "i-4d5e6f700819ab345", state: "terminated", type: "t2.medium",
          statusCheck: "-", alarm: "-", az: "us-east-1d",
          publicIp: "-", privateIp: "-", vpc: "vpc-0ee334455",
          launchTime: "2024-06-08T11:11:11Z" },
        { name: "analytics-jupyter", id: "i-5e6f700819ab34567", state: "running", type: "m5.xlarge",
          statusCheck: "2/2 checks passed", alarm: "No alarms", az: "eu-west-1a",
          publicIp: "63.35.44.120", privateIp: "10.3.2.7", vpc: "vpc-0cc223344",
          launchTime: "2026-02-28T15:47:29Z" },
        { name: "monitoring-grafana", id: "i-6f700819ab3456789", state: "running", type: "t3.medium",
          statusCheck: "2/2 checks passed", alarm: "1 alarm", az: "us-east-1c",
          publicIp: "3.92.18.200", privateIp: "10.0.7.12", vpc: "vpc-0fa112233",
          launchTime: "2025-10-10T10:10:10Z" },
    ];

    // Sort state
    let sortKey = "name";
    let sortDir = "asc";
    let searchText = "";
    const selected = new Set();

    const tbody = document.getElementById('instances-body');
    const emptyState = document.getElementById('empty-state');
    const countEl = document.getElementById('instance-count');
    const footer = document.getElementById('footer-meta');
    const searchInput = document.getElementById('search-input');
    const searchClear = document.getElementById('search-clear');
    const selectAll = document.getElementById('select-all');

    function stateBadge(s) {
        const cls = ['running','stopped','pending','terminated','stopping'].includes(s) ? s : 'stopped';
        return `<span class="status ${cls}"><span class="dot"></span>${s}</span>`;
    }

    function statusCheckCell(v) {
        if (v === '-' || v == null) return '<span class="check na">–</span>';
        if (v.toLowerCase().startsWith('2/2')) return `<span class="check passed">✓ ${v}</span>`;
        if (v.toLowerCase().startsWith('1/2')) return `<span class="check failed">! ${v}</span>`;
        return `<span class="check na">${v}</span>`;
    }

    function alarmCell(v) {
        if (v === '-' || v == null) return '<span class="alarm">–</span>';
        if (v.toLowerCase().includes('no alarm')) return `<span class="alarm">⊘ ${v}</span>`;
        return `<span class="alarm active">⚠ ${v}</span>`;
    }

    function formatTime(iso) {
        if (!iso || iso === '-') return '–';
        try {
            const d = new Date(iso);
            return d.toISOString().replace('T', ' ').replace(/\.\d+Z$/, ' UTC');
        } catch (_) { return iso; }
    }

    function sortedFiltered() {
        const text = searchText.trim().toLowerCase();
        let rows = INSTANCES.filter(r => {
            if (!text) return true;
            return Object.values(r).some(v => String(v).toLowerCase().includes(text));
        });
        rows.sort((a, b) => {
            let av = a[sortKey] ?? '';
            let bv = b[sortKey] ?? '';
            if (sortKey === 'launchTime') {
                av = new Date(av).getTime() || 0;
                bv = new Date(bv).getTime() || 0;
            } else {
                av = String(av).toLowerCase();
                bv = String(bv).toLowerCase();
            }
            if (av < bv) return sortDir === 'asc' ? -1 : 1;
            if (av > bv) return sortDir === 'asc' ? 1 : -1;
            return 0;
        });
        return rows;
    }

    function render() {
        const rows = sortedFiltered();
        tbody.innerHTML = '';
        rows.forEach(r => {
            const tr = document.createElement('tr');
            if (selected.has(r.id)) tr.classList.add('selected');
            tr.innerHTML =
                `<td><input type="checkbox" class="checkbox row-check" data-id="${r.id}" ${selected.has(r.id) ? 'checked' : ''}/></td>` +
                `<td>${escapeHtml(r.name)}</td>` +
                `<td class="id-cell">${escapeHtml(r.id)}</td>` +
                `<td>${stateBadge(r.state)}</td>` +
                `<td>${escapeHtml(r.type)}</td>` +
                `<td>${statusCheckCell(r.statusCheck)}</td>` +
                `<td>${alarmCell(r.alarm)}</td>` +
                `<td>${escapeHtml(r.az)}</td>` +
                `<td>${escapeHtml(r.publicIp)}</td>` +
                `<td>${escapeHtml(r.privateIp)}</td>` +
                `<td class="id-cell">${escapeHtml(r.vpc)}</td>` +
                `<td>${formatTime(r.launchTime)}</td>`;
            tbody.appendChild(tr);
        });

        countEl.textContent = `(${rows.length}${searchText ? ' of ' + INSTANCES.length : ''})`;
        footer.textContent = `Showing ${rows.length} of ${INSTANCES.length} instances${selected.size ? ' · ' + selected.size + ' selected' : ''}`;
        emptyState.style.display = rows.length === 0 ? 'block' : 'none';
        updateSortIndicators();
        updateActionButtons();
        updateSelectAllState(rows);
        wireRowCheckboxes();
        syncContext(rows);
    }

    function escapeHtml(s) {
        return String(s ?? '').replace(/[&<>"']/g, c => ({
            '&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'
        }[c]));
    }

    function updateSortIndicators() {
        document.querySelectorAll('th.sortable').forEach(th => {
            const key = th.dataset.key;
            const ind = th.querySelector('.sort-indicator');
            if (key === sortKey) {
                ind.textContent = sortDir === 'asc' ? '▲' : '▼';
                ind.classList.remove('inactive');
            } else {
                ind.textContent = '↕';
                ind.classList.add('inactive');
            }
        });
    }

    function updateActionButtons() {
        const any = selected.size > 0;
        document.getElementById('connect-btn').disabled = !any;
        document.getElementById('state-btn').disabled = !any;
        document.getElementById('actions-btn').disabled = !any;
        updateStateMenuItems();
    }

    // Which selected rows are eligible for each lifecycle action
    function eligibleIdsFor(action) {
        const selectedRows = INSTANCES.filter(r => selected.has(r.id));
        switch (action) {
            case 'start':     return selectedRows.filter(r => r.state === 'stopped').map(r => r.id);
            case 'stop':      return selectedRows.filter(r => r.state === 'running').map(r => r.id);
            case 'reboot':    return selectedRows.filter(r => r.state === 'running').map(r => r.id);
            case 'terminate': return selectedRows.filter(r => r.state !== 'terminated').map(r => r.id);
            default:          return [];
        }
    }

    function updateStateMenuItems() {
        document.querySelectorAll('#state-menu .menu-item').forEach(item => {
            const action = item.dataset.action;
            item.disabled = eligibleIdsFor(action).length === 0;
        });
    }

    // Dropdown open/close + menu item handlers
    const stateBtn = document.getElementById('state-btn');
    const stateMenu = document.getElementById('state-menu');

    function closeStateMenu() {
        stateMenu.classList.remove('open');
        stateBtn.setAttribute('aria-expanded', 'false');
    }
    function openStateMenu() {
        stateMenu.classList.add('open');
        stateBtn.setAttribute('aria-expanded', 'true');
    }

    stateBtn.addEventListener('click', e => {
        e.stopPropagation();
        if (stateBtn.disabled) return;
        stateMenu.classList.contains('open') ? closeStateMenu() : openStateMenu();
    });
    document.addEventListener('click', e => {
        if (!document.getElementById('state-dropdown').contains(e.target)) closeStateMenu();
    });
    document.addEventListener('keydown', e => {
        if (e.key === 'Escape') closeStateMenu();
    });

    stateMenu.addEventListener('click', async e => {
        const item = e.target.closest('.menu-item');
        if (!item || item.disabled) return;
        closeStateMenu();
        await performAction(item.dataset.action);
    });

    async function performAction(action) {
        const ids = eligibleIdsFor(action);
        if (ids.length === 0) return;

        // Optimistic "in-flight" state
        const inFlight = { start: 'pending', stop: 'stopping', reboot: 'pending', terminate: 'terminated' }[action];
        const finalState = { start: 'running', stop: 'stopped', reboot: 'running', terminate: 'terminated' }[action];
        ids.forEach(id => {
            const r = INSTANCES.find(x => x.id === id);
            if (r) r.state = inFlight;
        });
        render();

        // Call the MCP server tool via the ext-apps bridge
        try {
            await app.callServerTool({
                name: "ec2Action",
                arguments: { action, instanceIds: ids },
            });
        } catch (err) {
            console.error("ec2Action failed", err);
        }

        // Settle to the final state after a short delay to simulate the lifecycle
        if (finalState !== inFlight) {
            setTimeout(() => {
                ids.forEach(id => {
                    const r = INSTANCES.find(x => x.id === id);
                    // Only advance if still in the transient state (user may have acted again)
                    if (r && r.state === inFlight) r.state = finalState;
                });
                render();
            }, 1500);
        }
    }

    function updateSelectAllState(visibleRows) {
        if (visibleRows.length === 0) {
            selectAll.checked = false;
            selectAll.indeterminate = false;
            return;
        }
        const visibleIds = visibleRows.map(r => r.id);
        const selectedVisible = visibleIds.filter(id => selected.has(id)).length;
        selectAll.checked = selectedVisible === visibleIds.length;
        selectAll.indeterminate = selectedVisible > 0 && selectedVisible < visibleIds.length;
    }

    function wireRowCheckboxes() {
        document.querySelectorAll('.row-check').forEach(cb => {
            cb.addEventListener('change', e => {
                const id = e.target.dataset.id;
                if (e.target.checked) selected.add(id); else selected.delete(id);
                render();
            });
        });
    }

    // Column header sort clicks
    document.querySelectorAll('th.sortable').forEach(th => {
        th.addEventListener('click', () => {
            const key = th.dataset.key;
            if (sortKey === key) {
                sortDir = sortDir === 'asc' ? 'desc' : 'asc';
            } else {
                sortKey = key;
                sortDir = 'asc';
            }
            render();
        });
    });

    // Search
    searchInput.addEventListener('input', e => {
        searchText = e.target.value;
        searchClear.style.display = searchText ? 'block' : 'none';
        render();
    });
    searchClear.addEventListener('click', () => {
        searchText = '';
        searchInput.value = '';
        searchClear.style.display = 'none';
        searchInput.focus();
        render();
    });

    // Select all
    selectAll.addEventListener('change', () => {
        const visible = sortedFiltered();
        if (selectAll.checked) {
            visible.forEach(r => selected.add(r.id));
        } else {
            visible.forEach(r => selected.delete(r.id));
        }
        render();
    });

    // Refresh (visual only)
    document.getElementById('refresh-btn').addEventListener('click', () => {
        const btn = document.getElementById('refresh-btn');
        btn.style.transform = 'rotate(360deg)';
        btn.style.transition = 'transform .6s';
        setTimeout(() => { btn.style.transform = ''; btn.style.transition = ''; }, 650);
        render();
    });

    async function syncContext(visibleRows) {
        const total = INSTANCES.length;
        const shown = visibleRows.length;
        const byState = visibleRows.reduce((acc, r) => {
            acc[r.state] = (acc[r.state] || 0) + 1;
            return acc;
        }, {});
        const stateSummary = Object.entries(byState)
            .map(([k, v]) => `${v} ${k}`).join(', ') || 'none';
        const sel = selected.size > 0
            ? ` Selected: ${Array.from(selected).join(', ')}.`
            : '';
        const filterPart = searchText
            ? ` Filter="${searchText}", sorted by ${sortKey} ${sortDir}.`
            : ` Sorted by ${sortKey} ${sortDir}.`;
        const summary = `EC2 instances — showing ${shown} of ${total} (${stateSummary}).${filterPart}${sel}`;

        // try {
        //     await app.sendMessage({
        //         role: "user",
        //         content: [{ type: "text", text: summary }],
        //     });
        // } catch (_) { /* best-effort */ }
    }

    render();
</script>
@endraw

</body>
</html>
